#/bin/bash

sudo yum update -y

sudo yum install git -y


# Download Docker--------------------------------------------------------------

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker

sudo systemctl start docker

sudo systemctl enable docker

# Download Docker compose--------------------------------------------------------------

sudo wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 

sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose

sudo chmod -v +x /usr/local/bin/docker-compose

# Download nodejs and npm--------------------------------------------------------------

sudo yum install nodejs -y

sudo npm install -g npm@latest 

# Download Moleculer Framework and Demo--------------------------------------------------------------

# sudo npm i moleculer --save

# sudo npm i moleculer-cli -g

# sudo mkdir moleculer
# cd moleculer

#sudo moleculer init project moleculer-demo

#yes "$(printf 'Y\n%.0s' {1..3})N$(printf '\n%.0s' {1..4})Y\nN\nY" | sudo moleculer init project moleculer-demo


-----------------------------------------------
process to create docker-compose.yml
---------------------------







