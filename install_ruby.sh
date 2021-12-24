#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install ruby-full ruby-bundler build-essential
ruby -v
bundler -v
