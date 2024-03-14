# Create the buffersize.conf file
sudo touch /etc/nginx/conf.d/buffersize.conf

# Add the buffer size directives
sudo bash -c 'cat > /etc/nginx/conf.d/buffersize.conf << EOL
client_body_buffer_size 32k;
client_max_body_size 8M;
client_header_buffer_size 4k;
client_body_in_file_only off;
client_body_temp_file_write_size 128k;
client_header_temp_file_write_size 128k;

large_client_header_buffers 4 16k;
server_names_hash_bucket_size 128;

client_body_timeout 12;
client_header_timeout 12;
keepalive_timeout 15;
send_timeout 10;
sendfile on;
tcp_nopush on;

gzip on;
gzip_comp_level 4;
gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

location ~*. (jpg|jpeg|png|gif|ico|css|js)$ {
expires 365d;

EOL'

# Test the Nginx configuration
nginx_test=$(sudo nginx -t)
test_result=$?

if [ $test_result -eq 0 ]; then
    echo "Nginx configuration is valid."
    echo "Reloading Nginx service..."
    sudo systemctl reload nginx
    echo "Nginx service reloaded successfully."
else
    echo "Nginx configuration test failed:"
    echo "$nginx_test"
fi