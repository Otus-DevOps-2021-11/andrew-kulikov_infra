#!/bin/bash

INTERNAL_IPV4=$1

sudo sed -i "s/__INTERNAL_IPV4__/$INTERNAL_IPV4/" /tmp/mongod.conf
sudo mv /tmp/mongod.conf /etc/mongod.conf
sudo systemctl stop mongod
sudo systemctl start mongod
