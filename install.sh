#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

TOKEN=${1:-NULL}
REGION=${2:-us}

if [ $TOKEN == NULL ]; then
    echo 'Please specify your auth token, you can get it here: https://dashboard.ngrok.com/auth'
    echo './install.sh <your_auth_token> <region:us|eu|ap|au> (optional)'
    exit 1
fi

echo 'Welcome, this script will install a autostart ngrok ssh service'
echo 'Author: Joaquim Ley, 2020'
echo 'Repository: https://github.com/JoaquimLey/ngrok-install/'

###### NGROK SERVICE #####
echo 'Adding boot ngrok service...'
echo '[Unit]
Description=ngrok
After=network.target

[Service]
ExecStart=/opt/ngrok/ngrok start --all --config /opt/ngrok/ngrok.yml
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
IgnoreSIGPIPE=true
Restart=always
RestartSec=3
Type=simple

[Install]
WantedBy=multi-user.target' > /lib/systemd/system/ngrok.service

###### NGROK CONFIG #####
echo "authtoken: ${TOKEN}
region: ${REGION}
tunnels:
  ssh:
    proto: tcp
    addr: 22" > ngrok.yml
    
mkdir -p /opt/ngrok
mv ngrok.yml /opt/ngrok

echo 'Downloading ngrok-stable-linux-amd64.zip'
cd /opt/ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip

echo 'Download complete, unziping'
unzip ngrok-stable-linux-amd64.zip
sudo rm -r ngrok-stable-linux-amd64.zip

chmod +x ngrok

echo 'Starting ngrok service...'
systemctl enable ngrok.service
systemctl start ngrok.service

echo 'ngrok tunnel is online!'
echo 'Check the ip: https://dashboard.ngrok.com/status'
