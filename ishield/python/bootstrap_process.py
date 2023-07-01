import random
from create_key import HsmKey
from generate_csr import GenerateCsr
from request_cert import CertRequest
from cert_handler import CertHandler
from validate_chain import CertValidator
from hsm_objects import HsmObjects
import os
import logger

class BootstrapDevId:
    def __init__(self, pin, slot):

        self.logger = logger.get_logger("Bootstrap DevID")
        self.pin = pin
        self.slot = slot
        self.key_generated = False
        self.csr_generated = False
        self.cert_path = None
        self.valid_idev = None
        self.idev = False
        self.ldev = False


    def setup_idev_id(self):

        self.idev = True
        self.id = 100 # id 100 is reserved for the IDevID
        self.private_key_label="idev_pvt_key_{}".format(self.id)
        self.public_key_label="idev_pub_key_{}".format(self.id)

        self.presetup()

    def setup_ldev_id(self, id=None):

        self.ldev = True
        if id:
            self.id = id
        else:
            self.id = random.randint(10000, 99999)

        self.private_key_label = "ldev_pvt_key_{}".format(self.id)
        self.public_key_label = "ldev_pub_key_{}".format(self.id)

        self.presetup()


    def presetup(self):

        self.validate_key_label_exists()
        self.cn="test_cn_{}".format(self.id)
        self.serial_number=self.id

        self.create_directory("/home/admin/certs")
        self.create_directory("/home/admin/certs/id_{}".format(self.id))


    def create_directory(self, directory_path):

        if not os.path.exists(directory_path):
            os.makedirs(directory_path)
            self.logger.info(f"Created directory at {directory_path}")

    def create_key(self):
        self.logger.info("🔑 Create keypair")
        hsm_key = HsmKey(slot=self.slot,
                         pin=self.pin,
                         public_key_label=self.public_key_label,
                         private_key_label=self.private_key_label)
        hsm_key.generate_rsa_key_pair()
        self.key_generated = True

    def generate_csr(self, key_label=None, cn=None, o=None, ou=None, c=None, serial_number=None):
        self.logger.info("🖋️ Generate CSR")

        if self.key_generated:
            pre_label = "idev" if self.idev else "ldev"
            key_label = "{}_pvt_key_{}".format(pre_label, self.id)
        else:
            if key_label is None:
                raise Exception("key_label needs to be defined if there was no prior key generation")

        csr_generate = GenerateCsr(
            library_path='/usr/lib/opensc-pkcs11.so',
            slot_num=self.slot,
            pin=self.pin,
            key_label=key_label,
            output_file='/home/admin/certs/id_{}/csr_{}.csr'.format(self.id, self.id)
        )
        if cn:
            self.cn=cn
        if serial_number:
            self.serial_number=serial_number

        csr_generate.generate_csr(cn=self.cn,
                                  serial_number=self.serial_number,
                                  o=o,
                                  ou=ou,
                                  c=c)

    def request_cert(self, base_url, p12_file, p12_pass, certificate_profile_name, end_entity_profile_name, certificate_authority_name):
        self.logger.info("📄 Request certificate")


        self.cert_path='/home/admin/certs/id_{}/ldev_cert_{}.cert.pem'.format(self.id, self.id)

        cert_req = CertRequest(
            base_url=base_url,
            p12_file=p12_file,
            p12_pass=p12_pass,
            csr_file='/home/admin/certs/id_{}/csr_{}.csr'.format(self.id, self.id),
        )

        cert_req.request_certificate(cert_file=self.cert_path,
                                     certificate_profile_name=certificate_profile_name,
                                     end_entity_profile_name=end_entity_profile_name,
                                     certificate_authority_name=certificate_authority_name)

    def import_certificate(self):
        self.logger.info("⬆️ Import certificate")

        insert_cert = CertHandler(
            pin=self.pin,
            cert_id=self.id,
        )
        insert_cert.insert_certificate(slot=self.slot,
                                       cert_label=self.cn,
                                       certificate_path=self.cert_path)

    def export_certificate(self, cert_id, tmp_cert_path):
        export_cert = CertHandler(
            pin=self.pin,
            cert_id=cert_id,
        )
        export_cert.export_certificate(output_file=tmp_cert_path)

    def validate_idev_certifificate(self, ca_chain_url, idev_cert_path):
        self.logger.info("？ Validate certificate")

        self.logger.info("-Export IDev Certificate to tmp storage")
        self.export_certificate(cert_id=100, tmp_cert_path='/home/admin/certs/id_{}/idev.cert.pem'.format(self.id))

        public_web_validator = CertValidator()
        public_web_validator._load_ca_certs_via_public_web(ca_chain_url)
        self.valid_idev = public_web_validator.validate(idev_cert_path)

    def validate_key_label_exists(self):
        hsm_objects = HsmObjects(
            slot_num=self.slot,
            pin=self.pin
        )
        key_label_on_hsm = hsm_objects.filter_id_by_label(key_name=self.private_key_label)
        if key_label_on_hsm is not None:
            Exception("key label already exists for key label: {}".format(self.private_key_label))

    def configure_azure(self):
        self.logger.info("🛠️ Work in progress")


def bootstrap_idev():
    idevid = BootstrapDevId(pin="1234", slot=0)
    idevid.setup_idev_id()
    idevid.create_key()
    idevid.generate_csr()
    idevid.request_cert(base_url='campuspki.germanywestcentral.cloudapp.azure.com',
                           p12_file='/home/admin/fhk_hmi_setup_v3.p12',
                           p12_pass='foo123',
                           certificate_profile_name='DeviceIdentity-Raspberry',
                           end_entity_profile_name='KF-CS-EE-DeviceIdentity-Raspberry',
                           certificate_authority_name='KF-CS-HMI-2023-CA')
    idevid.import_certificate()

def bootstrap_ldev():
    ldevid = BootstrapDevId(pin="1234", slot=0)
    ldevid.setup_ldev_id()
    ldevid.validate_idev_certifificate()
    ldevid.create_key()
    ldevid.generate_csr()
    ldevid.request_cert(base_url='campuspki.germanywestcentral.cloudapp.azure.com',
                           p12_file='/home/admin/fhk_hmi_setup_v3.p12',
                           p12_pass='foo123',
                           certificate_profile_name='DeviceIdentity-Raspberry',
                           end_entity_profile_name='KF-CS-EE-DeviceIdentity-Raspberry',
                           certificate_authority_name='KF-CS-HMI-2023-CA')
    ldevid.import_certificate()
    ldevid.configure_azure()

if __name__ == "__main__":
    bootstrap_idev()