#!/bin/bash

# Set the current date
current_date=$(date +'%Y%m%d')

# Define paths and filenames
output_dir="output"
log_file="logs/autopc_${current_date}.log"
output_file="${output_dir}/AutoPC_${current_date}.xlsx"

# Database connection details (including the port)
db_server="your_db_server:your_db_port"
db_name="your_db_name"
db_user="your_db_user"
db_password="your_db_password"

# Function to remove old files
remove_old_files() {
    # Remove old files in the "output" directory
    echo "Removing old files..."
    rm -f "${output_dir}/*"
}

# Execute the stored procedure and save the result as CSV
execute_stored_procedure() {
    local procedure_name="your_stored_procedure_name"
    local csv_file="${output_dir}/AutoPC_${current_date}.csv"

    # Execute the stored procedure and save the result as CSV
    echo "Executing stored procedure..."
    if ! sql_command_output=$(your_sql_command_here); then
        echo "Error: Failed to execute the stored procedure."
        echo "Error Details: $sql_command_output"
        exit 1
    fi

    # Store the output as a CSV file
    echo "$sql_command_output" > "$csv_file"
}

# Convert CSV to XLSX using LibreOffice
convert_csv_to_xlsx() {
    # Check if LibreOffice is installed
    if ! command -v libreoffice &> /dev/null; then
        echo "Error: LibreOffice is not installed."
        exit 1
    fi

    # Convert CSV to XLSX
    echo "Converting CSV to XLSX..."
    libreoffice --headless --convert-to xlsx --outdir "$output_dir" "${output_dir}/AutoPC_${current_date}.csv" 2>> "$log_file"
}

# Main script
main() {
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir" || { echo "Error: Failed to create the output directory."; exit 1; }

    # Initialize the log file
    echo "AutoPC Script Execution Log - $(date)" > "$log_file"

    # Remove old files
    remove_old_files

    # Execute the stored procedure
    execute_stored_procedure

    # Convert CSV to XLSX
    convert_csv_to_xlsx

    # Clean up temporary files if needed
}

# Run the main script
main
