#!/bin/bash

# Parse command-line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --certificate_path)
            CERTIFICATE_PATH="$2"
            shift
            shift
            ;;
        --hsm_slot)
            HSM_SLOT="$2"
            shift
            shift
            ;;
        --hsm_pin)
            HSM_PIN="$2"
            shift
            shift
            ;;
        --id)
            CERT_ID="$2"
            shift
            shift
            ;;
        --label)
            CERT_LABEL="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if certificate file exists
if [[ ! -f "$CERTIFICATE_PATH" ]]
then
    echo "Certificate file not found: $CERTIFICATE_PATH"
    exit 1
fi

# Use pkcs11-tool to insert certificate into HSM
pkcs11-tool --module /usr/lib/pkcs11/libsofthsm2.so \
            --slot "$HSM_SLOT" \
            --pin "$HSM_PIN" \
            --write-object "$CERTIFICATE_PATH" \
            --type cert \
            --id "$CERT_ID" \
            --label "$CERT_LABEL"

# Check if the certificate was successfully inserted
if [[ $? -ne 0 ]]
then
    echo "Failed to insert certificate into HSM"
    exit 1
else
    echo "Certificate inserted into HSM"
    exit 0
fi
