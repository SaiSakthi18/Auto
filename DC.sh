#!/bin/bash

# Get the current day of the week (1 = Monday, 2 = Tuesday, ..., 7 = Sunday)
current_day=$(date +%u)

# Load database properties from the etc directory
if [ -f "etc/db.properties" ]; then
    source "etc/db.properties"
else
    echo "Error: etc/db.properties file not found."
    exit 1
fi

# Determine the query to use based on the current day
if [ "$current_day" -eq 1 ]; then
    query="$query_monday"
else
    query="$query_other_days"
fi

# Output CSV file in the output directory
output_csv="output/DiscardedCases.csv"

# Output Excel file in the output directory
output_excel="output/DiscardedCases.xlsx"

# Log file in the logs directory
log_file="logs/DiscardedCases.txt"

# Function to log errors and exit with an error code
log_error_and_exit() {
  local error_message="$1"
  echo "Error: $error_message" >> "$log_file"
  exit 1
}

# Function to log query issues and errors and exit with an error code
log_query_error_and_exit() {
  local error_message="$1"
  echo "SQL Query Error: $error_message" >> "$log_file"
  exit 2
}

# Log entry: Starting SQL query execution
echo "Starting SQL query execution..." >> "$log_file"

# Execute SQL query and save result as CSV
sqlcmd -S "$server,$port" -d "$database" -U "$username" -P "$password" -Q "$query" -o "$output_csv" -s "," -W -w 700 2>> "$log_file" || log_query_error_and_exit "SQL query execution failed."

# Log entry: SQL query executed successfully
echo "SQL query executed successfully." >> "$log_file"

# Check if the output file is empty (query returned no results)
if [ ! -s "$output_csv" ]; then
  log_query_error_and_exit "SQL query returned no results."
fi

# Log entry: SQL query returned results
echo "SQL query returned results." >> "$log_file"

# Log entry: Removing hyphens from the CSV file
echo "Removing hyphens from the CSV file..." >> "$log_file"

# Remove hyphens after the header using sed
sed -i '/^--/d' "$output_csv" || log_query_error_and_exit "Hyphen removal failed."

# Log entry: Hyphens removed from the CSV file
echo "Hyphens removed from the CSV file." >> "$log_file"

# Log entry: Converting CSV to Excel
echo "Converting CSV to Excel..." >> "$log_file"

# Convert CSV to Excel using LibreOffice
libreoffice --convert-to xlsx "$output_csv" --outdir "output" 2>> "$log_file" || log_query_error_and_exit "CSV to Excel conversion failed."

# Log entry: CSV converted to Excel successfully
echo "CSV converted to Excel successfully." >> "$log_file"

# Clean up the CSV file (optional)
rm "$output_csv"

echo "Result saved as $output_excel"
