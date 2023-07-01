#!/bin/bash

# Set the path to the PKCS11 tool
PKCS11_TOOL=/usr/bin/pkcs11-tool

# Parse command line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --key_type)
        key_type="$2"
        shift
        shift
        ;;
        --id)
        id="$2"
        shift
        shift
        ;;
        --pin)
        pin="$2"
        shift
        shift
        ;;
        *)
        echo "Unknown option: $key"
        exit 1
        ;;
    esac
done

# Check that all required arguments were provided
if [[ -z "$key_type" || -z "$id" || -z "$pin" ]]
then
    echo "Usage: $0 --key_type <key_type> --id <id> --pin <pin>"
    exit 1
fi

# Run the PKCS11 tool command to delete the object
$PKCS11_TOOL --delete-object --type "$key_type"key --id=$id --login --pin $pin
