from generate_csr import GenerateCsr
from request_cert import CertRequest
from create_key import HsmKey
import random


if __name__ == "__main__":
    random_id = random.randint(1000, 9999)
    csr_file = '/home/admin/certs/csr_{}.csr'.format(random_id)
    private_key_label = "ldev_pvt_key_{}".format(random_id)

    hsm_key = HsmKey(slot=0,
                     pin="1234",
                     public_key_label="ldev_pub_key_{}".format(random_id),
                     private_key_label=private_key_label)
    hsm_key.generate_rsa_key_pair()

    print("--- Generate CSR ---")
    csr_generate = GenerateCsr(
        slot_num=0,
        pin='1234',
        key_label=private_key_label,
        output_file=csr_file
    )
    csr_generate.generate_csr(cn="test_cn_{}".format(random_id),
                              serial_number=random_id)

    cert_req = CertRequest(
        base_url='campuspki.germanywestcentral.cloudapp.azure.com',
        p12_file='/home/admin/certs/fhk_hmi_setup_v3.p12',
        p12_pass='foo123',
        csr_file=csr_file,
    )

    cert_req.request_certificate(cert_file='/home/admin/certs/my_cert_{}.pem'.format(random_id),
                                 certificate_profile_name='DeviceIdentity-Raspberry',
                                 end_entity_profile_name='KF-CS-EE-DeviceIdentity-Raspberry',
                                 certificate_authority_name='KF-CS-HMI-2023-CA')
