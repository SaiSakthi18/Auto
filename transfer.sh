#!/bin/bash

# Define source file and destination directory
source_file="/path/to/source/file.txt"
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