#!/bin/bash

# Get the current day of the week (1 = Monday, 2 = Tuesday, ..., 7 = Sunday)
current_day=$(date +%u)

# Load database properties
if [ -f "db.properties" ]; then
    source "db.properties"
else
    echo "Error: db.properties file not found."
    exit 1
fi

# Determine the query to use based on the current day
if [ "$current_day" -eq 1 ]; then
    query="$query_monday"
else
    query="$query_other_days"
fi

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