#!/bin/bash

# Usage
# bash /home/admin/devid_raspi/ishield/request_cert.sh "campuspki.germanywestcentral.cloudapp.azure.com" "/home/admin/fhk_hmi_setup_v3.p12" "foo123" "/home/admin/test_csr_setup_1.csr"

EJBCA_BASE_URL=$1
P12_TOKEN=$2
P12_PASS=$3
CSR_FILE=$4

cert_profile_name="DeviceIdentity-Raspberry"
ee_profile_name="KF-CS-EE-DeviceIdentity-Raspberry"
ca_name="KF-CS-HMI-2023-CA"

csr=$(cat $CSR_FILE)
template='{"certificate_request":$csr, "certificate_profile_name":$cp, "end_entity_profile_name":$eep, "certificate_authority_name":$ca}'
json_payload=$(jq -n \
    --arg csr "$csr" \
    --arg cp "$cert_profile_name" \
    --arg eep "$ee_profile_name" \
    --arg ca "$ca_name" \
    "$template")

escaped_payload=$(echo "$json_payload" | sed 's/"/\\"/g')

# openssl pkcs12 -in fhk_hmi_setup_v3.p12 -out fhk_hmi_setup_v3.cert.pem -nodes -password pass:foo123

mkdir -p /home/admin/certs

openssl pkcs12 -in $P12_TOKEN -out /home/admin/certs/key.pem -nocerts -nodes -password pass:$P12_PASS
openssl pkcs12 -in $P12_TOKEN -out /home/admin/certs/crt.pem -clcerts -nokeys -password pass:$P12_PASS

echo $escaped_payload

#curl_response=$(curl -X POST -s \
#    --cert-type P12 \
#    --cert "$client_cert" \
#    -H 'Content-Type: application/json' \
#    -H  "accept: application/json" \
#    --data "$json_payload" \
#    "https://$EJBCA_BASE_URL/ejbca/ejbca-rest-api/v1/certificate/pkcs10enroll")


curl_response=$(curl -k \
    --cert /home/admin/certs/crt.pem \
    --cert-type PEM \
    --key /home/admin/certs/key.pem \
    --key-type PEM \
    -X POST "https://$EJBCA_BASE_URL/ejbca/ejbca-rest-api/v1/certificate/pkcs10enroll" \
    -H  "accept: application/json" \
    -H  "Content-Type: application/json" \
    -d "$escaped_payload")

rm /home/admin/certs/key.pem
rm /home/admin/certs/crt.pem

echo
echo "Response:"
echo "$curl_response"