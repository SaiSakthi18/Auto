#!/bin/bash

# Check if source file path is provided
if [ -z "$1" ]; then
    echo "Error: Source file path not provided."
    echo "Usage: $0 <source_file>"
    exit 1
fi

# Extract source file path from the argument
source_file="$1"

# Define destination directory
destination_directory="/path/to/destination/"

# Delete previous files from the destination directory
rm -f "${destination_directory}"/*

# Copy the file to the destination directory
cp "${source_file}" "${destination_directory}"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "File copied successfully to ${destination_directory}"
else
    echo "Failed to copy file to ${destination_directory}"
fi