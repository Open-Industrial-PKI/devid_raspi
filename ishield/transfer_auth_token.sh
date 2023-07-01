#!/bin/bash

# Usage
# bash transfer_auth_token.sh "hmipidev15.local" "admin" "./token/fhk_hmi_setup_v3.p12"

HOSTNAME=$1
USERNAME=$2
FILENAME=$3

scp $FILENAME $USERNAME@$HOSTNAME:/home/$USERNAME