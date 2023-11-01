#!/bin/bash

# Set the current date
current_date=$(date +'%Y%m%d')

# Define paths and filenames
output_dir="output"
log_file="logs/autopc_${current_date}.log"
output_file="${output_dir}/AutoPC_${current_date}.xlsx"
csv_file="${output_dir}/AutoPC_${current_date}.csv"

# Database connection details (including the port)
db_server="your_db_server"
db_port="your_db_port"  # Add your SQL Server port number
db_name="your_db_name"
db_user="your_db_user"
db_password="your_db_password"

# Stored procedure name
procedure_name="your_stored_procedure_name"

# Function to remove old files
remove_old_files() {
    # Remove old files in the "output" directory
    echo "Removing old files..."
    rm -f "${output_dir}/*"
}

# Function to get column names dynamically
get_column_names() {
    echo "Retrieving column names..."
    # Use sqlcmd to execute the stored procedure and fetch the column names
    # Replace 'your_stored_procedure_name' with the actual stored procedure name
    # You may need to add other connection options like -S, -U, -P, etc.
    column_names=$(sqlcmd -S "your_db_server,${db_port}" -d "${db_name}" -U "${db_user}" -P "${db_password}" -Q "SET NOCOUNT ON; EXEC your_stored_procedure_name" -h -1 | head -n 1)
}

# Execute the stored procedure and save the result as CSV
execute_stored_procedure() {
    # Execute the stored procedure and append the result to the CSV file
    echo "Executing stored procedure..."
    sqlcmd -S "${db_server},${db_port}" -d "${db_name}" -U "${db_user}" -P "${db_password}" -Q "SET NOCOUNT ON; EXEC $procedure_name" -s "," -h -1 >> "$csv_file"

    # Check for sqlcmd errors
    if [ $? -ne 0 ]; then
        echo "Error: Failed to execute the stored procedure."
        exit 1
    fi

    # Add the column names as the header to the CSV file
    sed -i "1s/^/${column_names}\n/" "$csv_file"
}

# Convert CSV to XLSX using LibreOffice
convert_csv_to_xlsx() {
    # Convert CSV to XLSX
    echo "Converting CSV to XLSX..."
    libreoffice --headless --convert-to xlsx --outdir "$output_dir" "$csv_file" 2>> "$log_file"
}

# Main script
main() {
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir" || { echo "Error: Failed to create the output directory."; exit 1; }

    # Initialize the log file
    echo "AutoPC Script Execution Log - $(date)" > "$log_file"

    # Remove old files
    remove_old_files

    # Get column names dynamically
    get_column_names

    # Execute the stored procedure and add column names to the CSV file
    execute_stored_procedure

    # Convert CSV to XLSX
    convert_csv_to_xlsx
}

# Run the main script
main
