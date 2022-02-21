#!/bin/bash
 exec > >(tee -i /var/log/stackscript.log)
#<UDF name="pat_password" Label="PAT" example="PAT" />
#Update the apt package index and install packages to allow apt to use a repository over HTTPS:
export DEBIAN_FRONTEND=noninteractive
 sudo apt-get -y  update
 sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
#Add Docker's official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#Use the following command to set up the stable repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#Update the apt package index, and install the latest version of Docker Engine, Docker Compose and Containerd
sudo apt-get -y update
sudo apt-get -y  install docker-ce docker-ce-cli containerd.io docker-compose
#Update apt package index, install latest version of nginx
sudo apt -y update
sudo apt -y install nginx
#clone repository
cd /home
git clone https://$PAT_PASSWORD@dev.azure.com/ozzitech/Ozzitech/_git/server-scripts
cd server-scripts
python3 clone.py
docker-compose up -d
