#!/bin/bash
read -p "username: " user
read -p "password: " pass

apt install git -y

clear

git clone https://github.com/noobz-id/noobzvpns.git && cd noobzvpns && ./install.sh

clear

noobzvpns --add-user $user $pass

systemctl enable noobzvpns
systemctl start noobzvpns