# cloud-metadata

This script is to get you started with the `cloud-init`. For more information on what `cloud-init-` does, refer to documentation at `https://cloudinit.readthedocs.io/en/latest`

## What this script will do

This script will allow you to,

* Set the `instance-id`
* Set the `local-hostname`
* Set a custom IP address
* Set a password for the `cloud-user` account
* Set a SSH key for the `cloud-user` account
* Create a ISO file in end.

## Tested on 

* RHEL 7 KVM Images

## Files created

Running the script will create the following files 

* `meta-data`
* `user-data`
* `init.iso`

## Running the script

The script is run as

	$ ./create_metadata.sh 
	Enter the image instance ID: (eg rhel-image) rhel-image
	Enter the image hostname: (eg rhel-image.local.lan) rhel-image.local.lan
	Do you want to give it a custom IP address? (y/n) y
	Enter the IP address: (eg 192.168.27.50) 192.168.27.50
	Enter the network: (eg 192.168.27.0) 192.168.27.0
	Enter the netmask: (eg 255.255.255.0) 255.255.255.0
	Enter the broadcast: (eg 192.168.27.255) 192.168.27.255
	Enter the gateway: (eg 192.168.27.4) 192.168.27.4
	Enter the password for the 'cloud-user': Enter the SSH Key for the 'cloud-user' 
	> your ssh key
	Creating the ISO file...


