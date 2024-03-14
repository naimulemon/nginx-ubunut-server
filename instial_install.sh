 #!/bin/bash

# Update package lists
sudo apt update

# Install required packages
sudo apt install -y gnupg2 wget ca-certificates

# Import the repository signing key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Set up the PostgreSQL repository based on Ubuntu version
RELEASE=$(lsb_release -cs)
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Update package lists again
sudo apt update

# Install the latest version of PostgreSQL
sudo apt install -y postgresql

# Check the installed version
psql --version

echo "PostgreSQL installation completed."


# Remove any existing Node.js installation
sudo apt-get remove -y nodejs npm

# Install required packages
sudo apt-get install -y curl gnupg

# Import the Node.js package signing key
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# Install Node.js and npm
sudo apt-get install -y nodejs

# Check the installed versions
node --version
npm --version

# Print a message
echo "Node.js and npm have been installed successfully!"


# Update package lists
sudo apt-get update

# Install required dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2

# Import the Nginx signing key
curl https://nginx.org/keys/nginx_signing.key | sudo gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg

# Add the Nginx repository
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" \
| sudo tee /etc/apt/sources.list.d/nginx.list > /dev/null

# Update package lists again
sudo apt-get update

# Install the latest version of Nginx
sudo apt-get install -y nginx

# Check the installed version
nginx -v

# Print a message
echo "Nginx has been installed successfully!"
