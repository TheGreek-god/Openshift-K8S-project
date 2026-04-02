# Flight Booking Application - Complete Deployment Guide

A Django-based flight booking system with Docker containerization and Azure Red Hat OpenShift (ARO) deployment.

## 📋 Table of Contents
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Docker Containerization](#docker-containerization)
- [Azure Red Hat OpenShift Deployment](#azure-red-hat-openshift-deployment)

## Features
- Search and book domestic & international flights
- PDF ticket generation with `xhtml2pdf`
- Admin interface for managing flights and bookings
- Dockerized for easy deployment
- Deployed on Azure Red Hat OpenShift (ARO)

## Technology Stack
| Component           | Technology                                |
|--------------------|-------------------------------------------|
| Backend             | Django 3.1.2                              |
| Database            | SQLite (can be upgraded to PostgreSQL)    |
| PDF Generation      | `xhtml2pdf`, ReportLab                     |
| Containerization    | Docker                                     |
| Orchestration       | OpenShift                     |
| Cloud Platform      | Azure Red Hat OpenShift (ARO)             |
| Container Registry  | Docker Hub                                 |

## Prerequisites
### 🏗️ Local Development Setup

- Python 3.11+
- Git
- Docker Desktop
- Docker Hub account

### ☁️ Azure OpenShift Deployment Prerequisites

- Azure subscription
- Azure Red Hat OpenShift cluster
- OpenShift CLI (`oc`)
- Docker Hub account with pushed image

## Local Development Setup
1. **Clone the Repository**

```bash
git clone https://github.com/yourusername/flight-app.git
cd flight-app
```
2. **Create Virtual Environment**
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/Mac
python -m venv venv
source venv/bin/activate
```
3. **Install Dependencies**
```bash
pip install -r requirements.txt
```
4. **Run Migrations**
```bash
python manage.py makemigrations
python manage.py migrate
```
5. **Load Initial Data**
```bash
python Data/add_places.py
```
6. **Create Superuser**
```
python manage.py createsuperuser
```
7. **Start Development Server**
```bash
python manage.py runserver
Access the app at: http://localhost:8000
```

## Docker Containerization
The project includes the following Docker configuration files:

| File                | Purpose                                                                                                                        |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------|
| Dockerfile          | Multi-stage Docker build configuration with Python 3.11-slim base, system dependencies for PDF generation (Cairo libraries), and security configurations (non-root user) |
| docker-compose.yml  | Local development orchestration with port mapping, volume mounting, and environment variables                                   |

## 🐳 Build and Test Locally

### Build Docker Image

```bash
# Build the Docker image (uses Dockerfile in root directory)
docker build -t flight-app:latest .
```
### Run with Docker Compose
```bash
# Uses docker-compose.yml
docker-compose up --build
```
### Or Run Directly
```bash
docker run -p 8000:8000 flight-app:latest
```
### 📦 Pushing to Docker Hub

1. **Login to Docker Hub**
```bash
docker login
# Enter username: greekgod659
# Enter password/token
```
2. **Tag Your Image**
```bash
# Tag with your Docker Hub username
docker tag flight-app:latest greekgod659/flight-app:latest
```
3. **Push to Docker Hub**
```bash
docker push greekgod659/flight-app:latest
```
Your image is now available at: https://hub.docker.com/r/greekgod659/flight-app

## Azure Red Hat OpenShift Deployment
### Step 1: Install OpenShift CLI

Download the `oc` client from your ARO cluster console:

```powershell
# Navigate to Downloads folder
cd C:\Users\myvm\Downloads

# Extract oc.exe (if in zip)
# Verify installation
.\oc.exe version
```
### Step 2: Login to OpenShift Cluster

Get your login token from the Azure Red Hat OpenShift (ARO) web console:

1. Open your ARO cluster web console.  
2. Click on your username → **Copy Login Command**.  
3. Click **Display Token**.  
4. Copy the full command and run it in PowerShell:

```powershell id="oc-login"
.\oc.exe login --token=sha256~YOUR_TOKEN_HERE --server=https://api.YOUR_CLUSTER.aroapp.io:6443
```
### Step 3: Create a Project
```powershell
# Create new project for your app
.\oc.exe new-project flight-app

# Verify the project
.\oc.exe project flight-app
```

### Step 4: Deploy Your Docker Image
```powershell
# Create deployment from Docker Hub image
.\oc.exe create deployment flight-app --image=greekgod659/flight-app:latest

# Check deployment status
.\oc.exe get deployments
.\oc.exe get pods
```
### Step 5: Expose the Application
```powershell
# Create a service (expose port 8000)
.\oc.exe expose deployment flight-app --port=8000 --target-port=8000

# Create a route for external access
.\oc.exe expose service flight-app

# Get the route URL
.\oc.exe get route

Expected output:

NAME         HOST/PORT
flight-app   flight-app-default.apps.YOUR_CLUSTER.aroapp.io
```

### Step 6: Configure Environment Variables
```powershell
# Set ALLOWED_HOSTS (critical for Django to accept requests)
.\oc.exe set env deployment/flight-app ALLOWED_HOSTS="*"

# Or set specific route URL
.\oc.exe set env deployment/flight-app ALLOWED_HOSTS="flight-app-default.apps.YOUR_CLUSTER.aroapp.io"

# Disable DEBUG mode for production
.\oc.exe set env deployment/flight-app DEBUG=0

# Set Django settings module
.\oc.exe set env deployment/flight-app DJANGO_SETTINGS_MODULE="capstone.settings"

# Wait for pod to restart
.\oc.exe rollout status deployment/flight-app
```
### Step 7: Run Database Migrations
```powershell
# Wait for pod to be ready
.\oc.exe get pods -w
# Press Ctrl+C when pod shows "Running"

# Run migrations
.\oc.exe exec -it deployment/flight-app -- python manage.py migrate

# Create superuser (optional)
.\oc.exe exec -it deployment/flight-app -- python manage.py createsuperuser
```
### Step 8: Verify Deployment
```powershell
# Check all resources
.\oc.exe get all

# View pod logs
.\oc.exe logs -f deployment/flight-app

# Check route URL
.\oc.exe get route
```

## 🌐 Accessing the Application

The application is now live at:

[https://flight-app-default.apps.YOUR_CLUSTER.aroapp.io](https://flight-app-default.apps.YOUR_CLUSTER.aroapp.io)

Admin interface:

[https://flight-app-default.apps.YOUR_CLUSTER.aroapp.io/admin](https://flight-app-default.apps.YOUR_CLUSTER.aroapp.io/admin)
