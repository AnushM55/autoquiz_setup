#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Git is installed
if ! command_exists git; then
  echo "Error: Git is not installed."
  echo "Please install Git and run the script again."
  exit 1
fi

# Define repository URL and directory name
BACKEND_REPO_URL="https://github.com/AnushM55/autoquiz_backend.git"
BACKEND_REPO_DIR="autoquiz_backend"

# Clone the repository if it doesn't exist
if [ ! -d "$BACKEND_REPO_DIR" ]; then
  echo "Cloning repository..."
  git clone "$BACKEND_REPO_URL"
else
  echo "Repository already exists. Pulling latest changes..."
  cd "$BACKEND_REPO_DIR"
  git pull
  cd ..
fi

# Change directory to the repository
cd "$BACKEND_REPO_DIR"

# Check if Python is installed
if ! command_exists python3; then
  echo "Error: Python3 is not installed."
  echo "Please install Python3 and run the script again."
  exit 1
fi

# Set up a virtual environment if not already present
if [ ! -d "venv" ]; then
  echo "Creating virtual environment..."
  python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Check if pip is installed
if ! command_exists pip; then
  echo "Error: pip is not installed."
  echo "Installing pip..."
  python3 -m ensurepip --default-pip
fi

# Install dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

cd ..

# Check if Node.js is installed
if ! command_exists node; then
  echo "Error: Node.js is not installed."
  echo "Please install Node.js (https://nodejs.org/) and run the script again."
  exit 1
fi

# Check if npm is installed
if ! command_exists npm; then
  echo "Error: npm is not installed."
  echo "Please install npm and run the script again."
  exit 1
fi

# Define repository URL and directory name
FRONTEND_REPO_URL="https://github.com/AnushM55/autoquiz_frontend.git"
FRONTEND_REPO_DIR="autoquiz_frontend"

# Clone the repository if it doesn't exist
if [ ! -d "$FRONTEND_REPO_DIR" ]; then
  echo "Cloning repository..."
  git clone "$FRONTEND_REPO_URL"
else
  echo "Repository already exists. Pulling latest changes..."
  cd "$FRONTEND_REPO_DIR"
  git pull
  cd ..
fi

# Change directory to the project
cd "$FRONTEND_REPO_DIR"

# Install dependencies
echo "Installing dependencies..."
npm install

cd ..
