#!/bin/bash

# Database connection parameters
server="your_server_name"
database="your_database_name"
username="your_username"
password="your_password"

# SQL query to run
query="SELECT * FROM your_table_name"

# Output CSV file
output_csv="output.csv"

# Output Excel file
output_excel="output.xlsx"

# Log file
log_file="script_log.txt"

# Function to log errors and exit with an error code
log_error_and_exit() {
  local error_message="$1"
  echo "Error: $error_message" >> "$log_file"
  exit 1
}

# Execute SQL query and save result as CSV
sqlcmd -S "$server" -d "$database" -U "$username" -P "$password" -Q "$query" -o "$output_csv" -s "," -W -w 700 || log_error_and_exit "SQL query execution failed."

# Remove hyphens after the header using sed
sed -i '/^--/d' "$output_csv" || log_error_and_exit "Hyphen removal failed."

# Convert CSV to Excel using LibreOffice
libreoffice --convert-to xlsx "$output_csv" --outdir $(pwd) || log_error_and_exit "CSV to Excel conversion failed."

# Clean up the CSV file (optional)
rm "$output_csv"

echo "Result saved as $output_excel"
