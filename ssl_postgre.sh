#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Directory containing SSL certificates
ssl_dir="/etc/ssl/postgresql"

# Path to PostgreSQL configuration file
pg_config="/etc/postgresql/<version>/main/postgresql.conf"  # Replace <version> with your PostgreSQL version

# Path to PostgreSQL HBA (Host-Based Authentication) file
pg_hba="/etc/postgresql/<version>/main/pg_hba.conf"  # Replace <version> with your PostgreSQL version

# Check if SSL certificate, key, and CA certificate files are provided
if [[ ! -f "<certificate_file>" || ! -f "<private_key_file>" || ! -f "<ca_certificate_file>" ]]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -new -x509 -days 365 -nodes -out "$ssl_dir/server.crt" -keyout "$ssl_dir/server.key" -subj "/CN=localhost"
    cp "$ssl_dir/server.crt" "$ssl_dir/root.crt"  # Use server.crt as CA certificate for self-signed certificates
else
    echo "Using provided SSL certificate files..."
    cp "<certificate_file>" "$ssl_dir/server.crt"
    cp "<private_key_file>" "$ssl_dir/server.key"
    cp "<ca_certificate_file>" "$ssl_dir/root.crt"
fi

# Set proper permissions for SSL files
chmod 600 "$ssl_dir/server.key"
chmod 644 "$ssl_dir/server.crt"
chmod 644 "$ssl_dir/root.crt"

# Update PostgreSQL configuration to use SSL
echo "ssl = on" >> "$pg_config"
echo "ssl_cert_file = '$ssl_dir/server.crt'" >> "$pg_config"
echo "ssl_key_file = '$ssl_dir/server.key'" >> "$pg_config"
echo "ssl_ca_file = '$ssl_dir/root.crt'" >> "$pg_config"

# Modify PostgreSQL HBA file to enforce SSL
sed -i "s/host    all             all             127.0.0.1\/32            md5/hostssl    all             all             127.0.0.1\/32            md5/g" "$pg_hba"

# Restart PostgreSQL server
service postgresql restart

echo "SSL certificate added successfully. PostgreSQL server has been restarted."
