#!/bin/bash

# use nginx public ip in the inventory and default files
ip=$(cat nginx-pub-ip.txt)
sed -i "s/PUB_IP/$ip/g" inventory.txt

ansible-playbook -i inventory.txt playbook.yml