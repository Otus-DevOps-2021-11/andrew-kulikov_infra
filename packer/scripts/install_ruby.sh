#!/bin/bash
apt-get -y update
apt-get -y upgrade
apt-get -y install ruby-full ruby-bundler build-essential
ruby -v
bundler -v
