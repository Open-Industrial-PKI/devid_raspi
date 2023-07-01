
Todo

Install jq for

```
apt-get install -y jq
```

Make the scripts executable

```
chmod +x ./bash/list_objects.sh
```


openssl req -engine pkcs11 -keyform engine -subj "/CN=dfffvvvvvvvvrrrvvv" -passin pass:1234 -key d0db40ae7f0000001000000000000000 -new -sha256 -out "/home/admin/test.csr"
target='
{Private Key Object; RSA:
[
{"label": "my_priv_rsa",
"ID": "68c962b61000000068c962b610000000",
"Usage": "decrypt, sign, unwrap",
"Access": "none"
}
]
Public Key Object; RSA 2048 bits:
[
{"label": "my_rsa_pub",
"ID": "68c962b61000000068c962b610000000",
"Usage": "encrypt, verify, wrap",
"Access": "none",
}
]
}
'


'Private Key Object; RSA \n    
    label:      my_priv_rsa\n  
    ID:         68c962b61000000068c962b610000000\n  
    Usage:      decrypt, sign, unwrap\n  
    Access:     none\n
Public Key Object; RSA 2048 bits\n  
    label:      my_rsa_pub\n  
    ID:         68c962b61000000068c962b610000000\n  
    Usage:      encrypt, verify, wrap\n  
    Access:     none\n
Private Key Object; RSA \n  
    label:      test\n  
    ID:         02\n  
    Usage:      decrypt, sign\n  
    Access:     none\n
Private Key Object; RSA \n  
    label:      test-2\n  
    ID:         03\n  
    Usage:      decrypt, sign\n  
    Access:     none\n
Public Key Object; RSA 2048 bits\n  
    label:      test\n  
    ID:         02\n  
    Usage:      encrypt, verify\n  
    Access:     none\n
Public Key Object; RSA 2048 bits\n  
    label:      test-2\n  
    ID:         03\n  
    Usage:      encrypt, verify\n  
    Access:     none\n
Profile object 3031686432\n  
profile_id:          CKP_PUBLIC_CERTIFICATES_TOKEN (4)\n'



Object 0:
	URL: pkcs11:model=PKCS%2315;manufacturer=unknown;serial=0000;token=JavaCard%20isoApplet%20%28User%20PIN%29;id=%10%5E%77%81%7F%00%00%00%10%00%00%00%00%00%00%00;object=ldev_pvt_key_7629;type=private
	Type: Private key (RSA-2048)
	Label: ldev_pvt_key_7629
	Flags: CKA_WRAP/UNWRAP; CKA_PRIVATE; 
	ID: 10:5e:77:81:7f:00:00:00:10:00:00:00:00:00:00:00

Object 1:
	URL: pkcs11:model=PKCS%2315;manufacturer=unknown;serial=0000;token=JavaCard%20isoApplet%20%28User%20PIN%29;id=%10%EC%BB%8F%7F%00%00%00%10%00%00%00%00%00%00%00;object=ldev_pvt_key_1461;type=private
	Type: Private key (RSA-2048)
	Label: ldev_pvt_key_1461
	Flags: CKA_WRAP/UNWRAP; CKA_PRIVATE; 
	ID: 10:ec:bb:8f:7f:00:00:00:10:00:00:00:00:00:00:00


"-----BEGIN CERTIFICATE-----""\n"
"MIICpDCCAYwCCQCfIjBnPxs5TzANBgkqhkiG9w0BAQsFADAUMRIwEAYDVQQDDAls""\n"
"dkyVdoGPCXc=""\n"
"-----END CERTIFICATE-----";


"Private ": "Key ": "Object; ": "RSA ": "label"my_priv_rsa ": "ID"68c962b61000000068c962b610000000 ": "Usage"decrypt, ": "sign, ": "unwrap ": "Access"none ": "Public ": "Key ": "Object; ": "RSA ": "2048 ": "bits ": "label"my_rsa_pub ": "ID"68c962b61000000068c962b610000000 ": "Usage"encrypt, ": "verify, ": "wrap ": "Access"none ": "Private ": "Key ": "Object; ": "RSA ": "label"test ": "ID"02 ": "Usage"decrypt, ": "sign ": "Access"none ": "Public ": "Key ": "Object; ": "RSA ": "2048 ": "bits ": "label"test ": "ID"02 ": "Usage"encrypt, ": "verify ": "Access"none ": "Profile ": "object ": "3031686432 ": "profile_id"CKP_PUBLIC_CERTIFICATES_TOKEN ": "(4) ":\n'