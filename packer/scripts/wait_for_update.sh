#!/bin/bash

i=0
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "[$i] Waiting for other software managers to finish..."
    sleep 0.5
    ((i=i+1))
done
