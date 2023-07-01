#!/bin/bash

# Parse command-line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --module)
            PKCS11_MODULE="$2"
            shift
            shift
            ;;
        --id)
            CERT_ID="$2"
            shift
            shift
            ;;
        --output_file)
            CERT_FILE="$2"
            shift
            shift
            ;;
        --pin)
            PIN="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Use pkcs11-tool to export certificate from HSM
pkcs11-tool --module "$PKCS11_MODULE" \
            --export-certificate \
            --type cert \
            --id "$CERT_ID" \
            --pin "$PIN" \
            --output-file "$CERT_FILE"

# Check if the certificate was successfully exported
if [[ $? -ne 0 ]]
then
    echo "Failed to export certificate from HSM"
    exit 1
else
    echo "Certificate exported from HSM"
    exit 0
fi
