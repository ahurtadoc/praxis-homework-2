#!/usr/bin/env bash

# Install golang
sudo yum update -y && sudo yum install golang -y

#Clean server folder
rm -rf /server && mkdir /server
#Copy golang app server
cp -R /shared/server / 

#create golang service
cd /etc/systemd/system
cat > go-server.service << EOF
[Unit]
Description=go server praxis

[Service]
Type=simple
Restart=always
RestartSec=5s
Environment="PORT=4001"
ExecStart=/server/vuego-demoapp

[Install]
WantedBy=multi-user.target
EOF

#Load go-server service
systemctl daemon-reload

#init api backend on port 4001
service go-server start

#verify service running correctly 
systemctl status go-server.service

# config to start backend at system boot
sudo systemctl enable go-server.service