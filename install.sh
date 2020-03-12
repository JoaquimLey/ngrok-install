#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

TOKEN=${1:-NULL}
REGION=${2:-us}

# Check for null token and/or invalid token length (49)
if [ $TOKEN == NULL ] || [ ${#TOKEN} != "49" ]; then
    echo 'ERROR: Please specify a valid auth token, you can get it here: https://dashboard.ngrok.com/auth'
    exit 1
fi

# Check for valid region option
if [ "$REGION" != "us" ] && [ "$REGION" != "eu" ] && [ "$REGION" != "ap" ] && [ "$REGION" != "au" ]; then
   echo "Invalid region - ${REGION}"
   echo 'Please specify a valid option <us|eu|ap|au>:'
   echo 'us - United States of America (Dallas) - default'
   echo 'eu - Europe (Frankfurt)'
   echo 'ap - Asia/Pacific (Singapore)'
   echo 'au - Australia (Sydney)'
   echo 'e.g: ./install.sh <YOUR_AUTH_TOKEN> eu'
   exit 1;
fi

echo '
###################################################################
#                                                                 # 
#                ngrok BOOT SSH tunnel Installer                  #
#                          Welcome!                               # 
#   The script will install a boot-started ngrok ssh service on   #
#  your RaspberryPi - the script will fail if ran on another EVT  #
#                                                                 # 
# --------------------------------------------------------------- # 
#                                                                 # 
# Author: Joaquim Ley, 2020                                       #
# https://twitter.com/JoaquimLey                                  # 
#                                                                 # 
# Repository: https://github.com/JoaquimLey/ngrok-install/        #
#                                                                 # 
###################################################################'

####### NGROK SERVICE #####
echo 'Adding ngrok service to systemd...'
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

# Create ngrok folder and move config file there
mkdir -p /opt/ngrok
mv ngrok.yml /opt/ngrok

# Download zip from ngrok's official website
echo '

Downloading ngrok from https://ngrok.com/download (ngrok-stable-linux-amd64.zip)

'
cd /opt/ngrok/
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip

echo 'Download complete! unziping.....'
unzip ngrok-stable-linux-amd64.zip
# No need to keep the downloaded zip on the device
sudo rm -r ngrok-stable-linux-amd64.zip

chmod +x ngrok

echo 'Enabling ngrok.service'
sudo systemctl enable ngrok.service

echo 'Starting ngrok.service'
sudo systemctl start ngrok.service

echo '
🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥

          ! ngrok tunnel is online !
    Check the ip address on your dashboard

    https://www.dashboard.ngrok.com/status     
                                              
🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥

🎯
Now ssh into your pi with: ssh -p PORT_NUMBER pi@ngrok_ip_address.io

For example:
Go to your ngrok dashboard and see your device details
-----------------------------------------------------------------
| ▶ | tcp://0.tcp.eu.ngrok.io:11223 | 188.93.224.31 | eu | DATE |
-----------------------------------------------------------------

You can ssh into your pi with the following command:
----------------------------------------------------
ssh -p 11223 pi@0.tcp.eu.ngrok.io


Make sure to ⭐️ the repository, report any bugs by opening an issue
https://github.com/JoaquimLey/ngrok-install/

You can always reach out to me on twitter:
https://twitter.com/JoaquimLey

Happy remote sshing!

Cheers,
Joaquim Ley
'
