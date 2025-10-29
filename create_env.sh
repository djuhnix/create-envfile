#!/bin/bash

FILE_NAME=$1

# Check if .env.example exists
if [ ! -f ".env.example" ]; then
    echo "Error: .env.example not found!"
    exit 1
fi

# Copy .env.example to .env
cp .env.example "$FILE_NAME"

# Replace all occurrences of KEY=value with the current environment variables
while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and empty lines
    if [[ $line =~ ^#.*$ || -z $line ]]; then
        continue
    fi

    # Extract the key
    key=$(echo "$line" | cut -d '=' -f 1)

    # Check if the key exists as an environment variable
    if [ -n "${!key}" ]; then
        # Replace the line with the environment variable value
        sed -i "s|^$key=.*$|$key=${!key}|" .env
    fi
done < .env.example

echo ".env file created with current environment variables."