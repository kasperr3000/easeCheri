#!/bin/bash

# Define the sudo password
PASSWORD="cheri"

# Check if expect is installed, if not install it
if ! command -v expect &> /dev/null; then
    echo "expect is not installed. Installing expect..."
    echo "$PASSWORD" | sudo -S apt update
    sudo apt install -y expect
    if [ $? -eq 0 ]; then
        echo "expect is installed."
    else
        echo "Failed to install expect. Exiting."
        exit 1
    fi
else
    echo "expect is already installed."
fi

# Check if the directory exists, if not create it
if [ ! -d "$HOME/cheri/DATA" ]; then
    echo "Creating directory ~/cheri/DATA"
    sudo mkdir -p "$HOME/cheri/DATA"
else
    echo "Directory ~/cheri/DATA already exists"
fi

# Mount the shared directory using 9p
echo "Mounting the shared directory"
echo "$PASSWORD" | sudo -S mount -t 9p -o trans=virtio,version=9p2000.L shared_dir "$HOME/cheri/DATA"

# Check if the mount was successful
if mountpoint -q "$HOME/cheri/DATA"; then
    echo "Mount successful"
else
    echo "Mount failed"
fi

# Add commands to the history
echo "ccc riscv64-purecap example.c -o example_cap" >> ~/.bash_history
echo "ccc riscv64 example.c -o example" >> ~/.bash_history
echo "~/cheribuild/cheribuild.py run-riscv64-purecap" >> ~/.bash_history

# Reload the history
history -r

echo "Commands added to history."


# Create the start_cheribsd.sh script
cat <<EOF > ~/start_cheribsd.sh
#!/usr/bin/expect -f

# Define the password
set PASSWORD "cheri"

# Start the VM
spawn ~/cheribuild/cheribuild.py run-riscv64-purecap

# Wait for the VM to boot
sleep 60

# Send 'root' for login
expect "login:"
send "root\r"

# Wait for the root prompt
expect "# "

# Execute the SMBFS script
send "mount_smbfs -I 10.0.2.4 -N //10.0.2.4/source_root /mnt\r"

# Keep the script running
interact
EOF

# Make the start_cheribsd.sh script executable
chmod +x ~/start_cheribsd.sh

# Execute the start_cheribsd.sh script
~/start_cheribsd.sh
