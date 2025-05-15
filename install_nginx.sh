#!/bin/bash

echo "📦 Updating package cache and installing NGINX..."
sudo dnf update -y
sudo dnf install -y nginx

echo "🟢 Enabling and starting NGINX service..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "📄 Copying HTML file to NGINX root..."
sudo cp /home/ec2-user/scm-polling/index.html /usr/share/nginx/html/index.html

echo "✅ Deployment complete! NGINX is running."

