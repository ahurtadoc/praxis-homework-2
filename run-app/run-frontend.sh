#!/usr/bin/env bash
sudo yum update -y && sudo yum install nginx -y

#Clean app folder
rm -rf /app && mkdir /app

#Copy and extract front in app/dist folder
cp /shared/spa/dist.tar.gz /app/dist.tar.gz
cd /app && sudo tar -zxf dist.tar.gz

#Config nginx to vue app
cat > /etc/nginx/nginx.conf << EOF
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
  worker_connections  1024;
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  65;
  server {
    listen       80;
    server_name  localhost;
    location / {
      root   /app/dist;
      index  index.html;
      try_files $uri $uri/ /index.html;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
}
EOF

# Load nginx new configuration
sudo systemctl reload nginx
# start or restart ngninx
sudo systemctl start nginx || sudo systemctl restart nginx 
sudo systemctl status nginx
# config to start at system boot
sudo systemctl enable nginx

