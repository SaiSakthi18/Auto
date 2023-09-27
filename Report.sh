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

# Execute SQL query and save result as CSV
sqlcmd -S $server -d $database -U $username -P $password -Q "$query" -o $output_csv -s "," -W -w 700

# Convert CSV to Excel using LibreOffice
libreoffice --convert-to xlsx $output_csv --outdir $(pwd)

# Clean up the CSV file (optional)
rm $output_csv

echo "Result saved as $output_excel"
