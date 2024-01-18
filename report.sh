#!/bin/bash

# Set your SQL Server connection details
SQL_SERVER="your_sql_server"
DATABASE="your_database"
USERNAME="your_username"
PASSWORD="your_password"
PORT_NUMBER="your_port_number"  # Replace with the actual port number

# Set query to execute
SQL_QUERY="SELECT * FROM your_table;"

# Set paths
LOG_FOLDER="logs"
OUTPUT_FOLDER="output"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_FOLDER/script_log_$TIMESTAMP.txt"
OUTPUT_FILE="$OUTPUT_FOLDER/errReport_$TIMESTAMP.xlsx"

# Create folders if they don't exist
mkdir -p "$LOG_FOLDER"
mkdir -p "$OUTPUT_FOLDER"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Trap function for cleanup on script exit
cleanup() {
    log "Script interrupted. Cleaning up..."
    rm -f "$OUTPUT_FILE" "$OUTPUT_FILE.csv"
    exit 1
}

trap cleanup INT TERM EXIT

# Execute SQL query and store the results in a CSV file
log "Executing SQL query..."

query_result=$(sqlcmd -S "$SQL_SERVER,$PORT_NUMBER" -d "$DATABASE" -U "$USERNAME" -P "$PASSWORD" -Q "$SQL_QUERY" -s "," -W)

if [ $? -eq 0 ]; then
    # Write the result to the CSV file and format cells as number
    (echo "Your,Header,Names"; echo "$query_result") | awk 'BEGIN {FS=OFS=","} {for (i=1; i<=NF; ++i) $i = "\"" $i "\"" } 1' > "$OUTPUT_FILE.csv"
    log "SQL query executed successfully."

    # Convert CSV to Excel and apply cell formatting
    log "Converting CSV to Excel and formatting cells..."
    libreoffice --headless --convert-to xlsx --infilter=CSV:44,34,UTF8 "$OUTPUT_FILE.csv" --outdir "$OUTPUT_FOLDER"
    log "Excel file generated successfully."
else
    log "Error executing SQL query. Details: $query_result"
    exit 1
fi


# Remove temporary CSV file
rm -f "$OUTPUT_FILE.csv"

log "Script executed successfully. Output saved to: $OUTPUT_FILE"

# Remove trap on successful execution
trap - INT TERM EXIT
