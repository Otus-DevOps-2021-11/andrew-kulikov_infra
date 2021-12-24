#!/bin/bash
echo "deb http://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.4.list
echo "deb http://repo.pritunl.com/stable/apt focal main" > /etc/apt/sources.list.d/pritunl.list
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt-get --assume-yes install pritunl mongodb-org
systemctl start pritunl mongod
systemctl enable pritunl mongod
