#!/bin/sh -l

echo "Setuping SSH Key"

mkdir -p /root/.ssh
echo "$SSH_PRIVATE_KEY" | tr -d '\r' > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh_host=$(echo $DOKKU_REPO | sed -e 's/.*@//' -e 's/[:/].*//')
# Extract port number. Defaults to port 22.
ssh_port=$(echo $DOKKU_REPO | sed -e 's/.*@//' -e 's/\/.*//' -ne 's/.*:\([0-9]*\)/\1/p')
ssh-keyscan -H -p "${ssh_port:=22}" "$ssh_host" >> /root/.ssh/known_hosts
eval "$(ssh-agent -s)"
ssh-add /root/.ssh/id_rsa