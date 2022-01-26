#!/bin/bash

MONGODB_URL=$1
echo "using mongodb url $MONGODB_URL"

git clone -b monolith https://github.com/express42/reddit.git $HOME/reddit
cd $HOME/reddit
bundle install
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
