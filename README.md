# GOAL:
Get 2 terminals one with the RISCV VM, one to just compile the .c files.
They both connected to `~/shared_directory_name/` wich will be translated in the VM's to directory name `~/cheri/DATA`.
(I edited the .c files outside the VMs)

# start VM
I started my VM with parameters to init a ssh and share a directory:
`qemu-system-x86_64 -enable-kvm -m 4096 -snapshot -virtfs local,path=~/shared_directory_name/,mount_tag=shared_dir,security_model=passthrough,id=shared -net user,hostfwd=tcp::2222-:22 -net nic /home/zeus/Projects/capita_selecta_ss/cheri/cheriVM.qcow2`

The shared map:
`path=~/shared_directory_name/`

The port to start ssh server:
`hostfwd=tcp::2222`

I did only use 2 ssh connected terminals without gui to complete this assignment: `-nographic`


# 1: RISCV terminal:
The first terminal that will setup the VM environment(mount and ease of commando's) and startdup the RISCV emulator.

## Connect to VM with ssh
`ssh -p 2222 cheri@localhost`

## execute script in VM
I used git to ease the script retreival:
`git clone https://github.com/kasperr3000/easeCheri.git`

`chmod +x easeCheri/mount_dir.sh`

`./easeCheri/mount_dir.sh`

## extra
[wait till the RISCV emulator has started and the changed to the DATA directory]
The have a more robust automation, a sleep timer is setted to 90 seconds (on slow computers maybe increase the sleep time).

### note
It is important that somewhere under the `DATA` directory the `capita-cheri.a` file is located as it is searched by the script to reference.



# 2: ccc terminal:
The second terminal should be initiated after the first one has finished the script. It can therefor make use from an alias and commands in history

## Connect to VM with ssh
`ssh -p 2222 cheri@localhost`

## go to files to compile
`cd cheri/DATA/...`

## extra
To compile every .c file in a directory in a sequence use the allias:
`cheri_compile`
