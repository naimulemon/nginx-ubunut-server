# Find The Ulimit Number (This is for nignx server worker connection per second limit, set the value on nginx.conf worker connect limit)
ulimit -n

# Rate Limiting
# Set the value on nginx.conf
limit_req_zone $request_uri zone=one:10m rate=10r/s;

# add Http Request Rate Limiting
sudo bash -c 'cat >> /etc/nginx/conf.d/ratelimit.conf << EOL
limit_req_zone $request_uri zone=one:10m burst=10 rate=10r/s nodelay;
EOL'