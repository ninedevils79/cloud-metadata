#!/usr/bin/env bash

#Copyright 2016 Kumar Jadav
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

USER_DATA=user-data
META_DATA=meta-data


meta_data_hostname()
{
  read -r -p "Enter the image instance ID: (eg rhel-image) " IMAGENAME
  read -r -p "Enter the image hostname: (eg rhel-image.local.lan) " IMAGEFQDN

cat > ${META_DATA} << EOF
instance_id: ${IMAGENAME}
local-hostname: ${IMAGEFQDN}
EOF
}

meta_data_ipaddress()
{
  read -r -p "Enter the IP address: (eg 192.168.27.50) " IPADDR
  read -r -p "Enter the network: (eg 192.168.27.0) " NETWORK
  read -r -p "Enter the netmask: (eg 255.255.255.0) " NETMASK
  read -r -p "Enter the broadcast: (eg 192.168.27.255) " BROADCAST
  read -r -p "Enter the gateway: (eg 192.168.27.4) " GATEWAY

cat >> ${META_DATA} << EOF
network-interfaces: |
  iface eth0 inet static
  address ${IPADDR}
  network ${NETWORK}
  netmask ${NETMASK}
  broadcast ${BROADCAST}
  gateway ${GATEWAY}

bootcmd:
  - ifdown eth0
  - ifup eth0
EOF
}

create_user_data()
{
  read -r -s -p "Enter the password for the 'cloud-user': " PASSWORD
  read -p "Enter the SSH Key for the 'cloud-user' `echo $'\n> '`" SSHKEY

cat > ${USER_DATA} << EOF
#cloud-config
password: ${PASSWORD}
ssh_pwauth: True
chpasswd: { expire: False }

ssh_authorized_keys:
  - ${SSHKEY}
EOF

}

is_genisoimage_installed()
{
  type -p genisoimage > /dev/null
}

generate_iso()
{
  if [[ -f init.iso ]]; then
    rm -r init.iso
  fi

  echo "Creating the ISO file..."
  genisoimage -output init.iso -volid cidata -joliet -rock user-data meta-data &>/dev/null
}


### Main
## meta-data related
meta_data_hostname

# Check if they want to give the user any IP address?
read -r -p "Do you want to give it a custom IP address? (y/n) " RESPONSE
RESPONSE=${RESPONSE,}
if [[ $RESPONSE =~ ^(yes|y) ]]; then
  meta_data_ipaddress
fi

## user-data related
create_user_data

## Check if genisoimage is installed
is_genisoimage_installed
if  [[ $? -ne 0 ]]; then
  echo "gemisoimage is not installed"
  echo "Installing genisoimage"
  yum install genisoimage -y
fi

## Generate the ISO 
generate_iso

