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

# Set the path to the pkcs11-tool and the PKCS#11 module
PKCS11_TOOL=/usr/bin/pkcs11-tool
PKCS11_MODULE=/usr/lib/opensc-pkcs11.so

$PKCS11_TOOL --module $PKCS11_MODULE --keypairgen --id "$ID" --label "$LABEL" --key-type rsa:2048 --login --pin "$PIN"

echo "Keypair has been generated with ID: $ID, label: $LABEL, and RSA key size of 2048 bits."
