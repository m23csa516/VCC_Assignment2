#!/bin/bash
set -euo pipefail

# ---- PRE-CHECKS ----
# Check if running as root/sudo
if [ "$EUID" -eq 0 ]; then
  echo "ERROR: Do not run this script as root/sudo. Run it as a normal user."
  exit 1
fi

# Check for required packages (curl, sudo)
if ! command -v curl &> /dev/null || ! command -v sudo &> /dev/null; then
  echo "Installing dependencies (curl, sudo)..."
  sudo apt-get update -qq && sudo apt-get install -y -qq curl sudo
fi

# ---- GCLOUD CLI INSTALLATION ----
if ! command -v gcloud &> /dev/null; then
  echo "Installing Google Cloud SDK..."
  sudo apt-get update -qq

  # Add Google Cloud SDK repository
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null

  # Import Google Cloud GPG key
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - > /dev/null

  # Install Google Cloud SDK
  sudo apt-get update -qq && sudo apt-get install -y -qq google-cloud-cli
fi

# ---- GCLOUD AUTH & CONFIG ----
# Check if authenticated
if ! gcloud auth list --format="value(account)" | grep -q "@"; then
  echo "Authenticate Google Cloud CLI. A browser window will open..."
  gcloud auth login
fi

# Set variables (customize these!)
PROJECT_ID="assignment2-450216"
REGION="us-central1"
ZONE="us-central1-a"
INSTANCE_TEMPLATE="web-instance-template"
INSTANCE_GROUP="web-instance-group"
MIN_REPLICAS=1
MAX_REPLICAS=5
TARGET_CPU_UTILIZATION=0.6
MY_IP="49.43.96.182/32"
SERVICE_ACCOUNT_EMAIL="default"
USER_EMAIL="m23csa516@iitj.ac.in"

# Configure project
gcloud config set project "$PROJECT_ID"
gcloud config set compute/region "$REGION"
gcloud config set compute/zone "$ZONE"

# ---- DEPLOY INFRASTRUCTURE ----
# Create instance template
echo "Creating instance template..."
gcloud compute instance-templates create "$INSTANCE_TEMPLATE" \
  --machine-type=e2-micro \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud \
  --tags=http-server,ssh-my-ip \
  --service-account="$SERVICE_ACCOUNT_EMAIL" \
  --scopes=cloud-platform \
  --metadata=startup-script='#!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "Hello from $(hostname)" > /var/www/html/index.html'

# Create managed instance group with auto-scaling
echo "Creating managed instance group..."
gcloud compute instance-groups managed create "$INSTANCE_GROUP" \
  --base-instance-name=web-instance \
  --template="$INSTANCE_TEMPLATE" \
  --size="$MIN_REPLICAS" \
  --zone="$ZONE"

# Configure auto-scaling policy
echo "Configuring auto-scaling..."
gcloud compute instance-groups managed set-autoscaling "$INSTANCE_GROUP" \
  --zone="$ZONE" \
  --min-num-replicas="$MIN_REPLICAS" \
  --max-num-replicas="$MAX_REPLICAS" \
  --target-cpu-utilization="$TARGET_CPU_UTILIZATION" \
  --cool-down-period=120

gcloud compute instance-groups managed set-named-ports "$INSTANCE_GROUP" \
  --zone="$ZONE" \
  --named-ports=http:80

# Configure firewall rules
echo "Setting up firewall rules..."
# Allow HTTP traffic
gcloud compute firewall-rules create allow-http \
  --allow=tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=http-server

# Allow SSH only from your public IP
gcloud compute firewall-rules create allow-ssh-my-ip \
  --allow=tcp:22 \
  --source-ranges="$MY_IP" \
  --target-tags=ssh-my-ip

# Allow health checks from Google IP ranges
gcloud compute firewall-rules create allow-health-check \
  --allow=tcp:80 \
  --source-ranges="130.211.0.0/22,35.191.0.0/16" \
  --target-tags=http-server

# ---- IAM ROLES ----
echo "Assigning IAM roles..."
# Assign Compute Viewer role to a user
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:er.himani1998@gmail.com" \
  --role=roles/compute.viewer

# Assign Compute Instance Admin role to a user (optional)
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$USER_EMAIL" \
  --role=roles/compute.instanceAdmin.v1

# ---- FINAL OUTPUT ----
echo "Setup complete!"
