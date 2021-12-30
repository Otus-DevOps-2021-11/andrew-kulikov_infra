#!/bin/bash
apt-get -y install git
mkdir /var/www
cd /var/www
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
