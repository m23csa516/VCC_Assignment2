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
