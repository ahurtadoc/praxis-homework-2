#!/usr/bin/env bash
git --version || ( sudo yum update -y && sudo yum install git -y ) 
sudo rm -rf app && sudo mkdir app && cd app
git clone https://github.com/jdmendozaa/vuego-demoapp.git .

#Build backend artifact -------------------------------------------------

#Install Golang
sudo yum install golang -y
#Delete and create server shared folder
rm -rf /shared/server && mkdir -p /shared/server
cd /home/vagrant/app/server
# create port enviroment variable and build go app
export PORT=4001
go build -o /shared/server

#Build frontent artifact --------------------------------------------

#install nodejs lts (14.18.1)
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
node --version || sudo yum install nodejs -y

# Go to project folder and install dependencies
cd /home/vagrant/app/spa && sudo npm install
# Config vue production enviroment
echo "VUE_APP_API_ENDPOINT"="http://localhost:4001/api" > .env.production
# build frontend 
npm run build
# move front to shared folder
tar -zcvf dist.tar.gz ./dist
rm -rf /shared/spa && mkdir -p /shared/spa
mv dist.tar.gz /shared/spa