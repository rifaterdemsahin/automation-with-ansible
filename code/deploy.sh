#!/bin/bash

# Check if appName parameter is passed
if [ -z "$1" ]; then
    echo "Usage: $0 <appName>"
    exit 1
fi

# Assign the first argument to appName variable
appName=$1

# Output the deployment message
echo "Deploying $appName..."
