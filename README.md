# Automating Scalable Cloud Infrastructures on Google Cloud Platform

This repository contains an automated solution for deploying a Managed Instance Group (MIG) on Google Cloud Platform (GCP) with auto-scaling. The deployment script provisions and configures virtual machines using an instance template, sets up auto-scaling, and implements security configurations with firewall rules and IAM roles.
## Overview

This project automates the deployment of a scalable and secure cloud infrastructure on GCP. The primary objectives are to:

- **Automate provisioning**: Use an instance template for consistent VM configuration.
- **Enable auto-scaling**: Dynamically adjust the number of instances based on CPU utilization.
- **Enforce security**: Implement IAM roles and firewall rules to secure the infrastructure.
- **Ensure cost efficiency**: Optimize resource usage by scaling in and out as needed.

## Features

- **Auto-Scaling**: Automatically adjusts the number of VM instances based on CPU usage.
- **Automated Provisioning**: Uses a pre-defined instance template for consistent setup.
- **Security Configuration**: Implements firewall rules and IAM roles to safeguard resources.
- **Cost Efficiency**: Scales resources dynamically to match workload demands.

## Pre-requisites

Before you begin, ensure you have the following:

- A GCP account with appropriate permissions.
- Google Cloud SDK installed on your machine.
- Basic knowledge of cloud infrastructure and Bash scripting.
- Non-root user privileges to avoid permission conflicts.

## Installation & Setup

1. **Clone the Repository:**

   ```bash
   git clone [https://github.com/m23csa516/VCC_Assignment2.git]
   cd VCC_Assignment2
   
2. **Install Dependencies:**

   The deployment script gcp_autoscaling.sh checks for dependencies such as curl and sudo. If missing, it will attempt to install them automatically.

3. **Configure Google Cloud SDK:**

   Set up the SDK with your project settings:
   
      ```bash
   
      gcloud auth login
      gcloud config set project YOUR_PROJECT_ID
      gcloud config set compute/region YOUR_REGION
      gcloud config set compute/zone YOUR_ZONE

4. **Deployment:**
   The deployment script performs the following tasks:
   
   Pre-checks: Verifies non-root execution and checks for necessary dependencies.
   
   SDK Installation: Installs the Google Cloud SDK if not already present.
   
   Authentication: Prompts for authentication if required.
   
   Instance Template Creation: Creates an instance template specifying:
   
   Machine Type: e2-micro
   
   Operating System: Ubuntu 20.04 LTS
   
   Startup Script: Installs Apache and serves a default webpage.
   
   Managed Instance Group Creation: Deploys a MIG using the created instance template.
   
   Auto-Scaling Configuration: Sets up policies to adjust the number of instances based on a target CPU utilization of 60%.
   
   Security Setup: Configures firewall rules to allow HTTP traffic on port 80 and restricts SSH access to specified IPs. Assigns necessary IAM roles.
   
   Run the deployment script with:

      ```
      bash gcp_autoscaling.sh
      
5. **Testing:**
   After deployment, validate the setup with the following tests:
   
   Auto-Scaling Verification:
   
   Simulate a high CPU workload:
   
         ```
         stress --cpu 4 --timeout 100s
      
    Security Checks:Confirm that firewall rules and IAM roles are correctly enforced, ensuring secure access to the VM instances.

## Recorded Video Link:https://drive.google.com/file/d/1Xzw1O-_5JhlpSjXX4M7cD42Hb70ZaTxV/view



