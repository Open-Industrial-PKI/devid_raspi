#!/bin/bash

echo "------"
echo "Basic setup for raspi"
echo "------"

echo "Create basic setup: update & upgrade"
sudo apt-get update && sudo apt-get upgrade -y

echo "Create basic setup: Load lshw"
sudo apt-get install lshw
echo "Usage:"
echo " - sudo lshw"
echo " - sudo lshw | less"

echo "Create basic setup: Show OS"
cat /etc/os-release