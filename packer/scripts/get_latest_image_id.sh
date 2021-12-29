#!/bin/bash
yc compute image get-latest-from-family "ubuntu-1604-lts" --folder-id standard-images | \
      grep ^id | \
      awk '{print $2}'
