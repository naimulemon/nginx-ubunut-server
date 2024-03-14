#!/bin/bash
#?? Please install Azure CLI using the following command:


# Set the database name and backup file name
DATABASE_NAME="your_database_name"
BACKUP_FILE="/tmp/$(date +%Y%m%d%H%M%S)_${DATABASE_NAME}.sql"

# Create a backup of the database
pg_dump ${DATABASE_NAME} > ${BACKUP_FILE}

# Get the Azure storage account name and container name
STORAGE_ACCOUNT_NAME="your_storage_account_name"
CONTAINER_NAME="your_container_name"

# Upload the backup file to Azure Blob Storage
az storage blob upload --account-name ${STORAGE_ACCOUNT_NAME} --container-name ${CONTAINER_NAME} --name $(basename ${BACKUP_FILE}) --file ${BACKUP_FILE}

# Remove the local backup file
rm ${BACKUP_FILE}

# Add These lines to your crontab
#? crontab -e
#?     0 0 * * * /path/to/backup_postgres.sh