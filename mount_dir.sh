#!/bin/bash

# Check if the directory exists, if not create it
if [ ! -d "$HOME/cheri/DATA" ]; then
    echo "Creating directory ~/cheri/DATA"
    sudo mkdir -p "$HOME/cheri/DATA"
else
    echo "Directory ~/cheri/DATA already exists"
fi

# Mount the shared directory using 9p
echo "Mounting the shared directory"
sudo mount -t 9p -o trans=virtio,version=9p2000.L shared_dir "$HOME/cheri/DATA"

# Check if the mount was successful
if mountpoint -q "$HOME/cheri/DATA"; then
    echo "Mount successful"
else
    echo "Mount failed"
fi
