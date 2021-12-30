#!/bin/bash
FOLDER_ID="b1gtckbo97fa9l1lqac7"
IMAGE_ID="fd8ic45ecoco94rc7nrc"
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=$FOLDER_ID,image-id=$IMAGE_ID \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --ssh-key ~/.ssh/appuser.pub \
  --metadata serial-port-enable=1
