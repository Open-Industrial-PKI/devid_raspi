


``` bash
openssl engine pkcs11 -t -c –vvvv
```

``` bash
/usr/bin/pkcs11-tool --module /usr/lib/opensc-pkcs11.so -L
```

``` bash
/usr/bin/pkcs11-tool --module /usr/lib/opensc-pkcs11.so --keypairgen --id "3" --label "setup_test_3" --key-type rsa:2048 --login --verbose
```

``` bash
openssl req -engine pkcs11 -keyform engine -subj "/CN=setup_test_5/serialNumber=12345678/" -key "3" -new -sha256 -out /home/admin/certs/setup_test_5.csr --verbose
```

``` bash
/usr/bin/pkcs11-tool --module /usr/lib/opensc-pkcs11.so --write-object device.pem.crt --type cert --id "3" --label "setup_test_3" --login
```