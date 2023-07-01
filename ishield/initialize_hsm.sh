#!/bin/bash

usage() {
  echo "Usage: $0 --id <ID> --label <LABEL> --pin <PIN>"
  exit 1
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --id)
    ID="$2"
    shift 2
    ;;
    --label)
    LABEL="$2"
    shift 2
    ;;
    --pin)
    PIN="$2"
    shift 2
    ;;
    *)
    usage
    ;;
esac
done

if [[ -z $ID ]] || [[ -z $LABEL ]] || [[ -z $PIN ]]; then
  usage
fi

# Set the path to the PKCS#15 module
PKCS15_TOOL=/usr/bin/pkcs15-init

$PKCS15_TOOL --create-pkcs15 --so-pin "$PIN" --pin "$PIN" --id "$ID" --label "$LABEL" --key-usage digitalSignature,keyEncipherment --auth-id 01 --generate-key rsa:2048

echo "HSM has been initialized with ID: $ID, label: $LABEL, and RSA key size of 2048 bits."
