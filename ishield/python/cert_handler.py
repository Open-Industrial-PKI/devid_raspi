import subprocess
import logger


class CertHandler:
    def __init__(self, pin, cert_id, pkcs11_module = '/usr/lib/opensc-pkcs11.so'):
        self.logger = logger.get_logger("CertHandler")

        self.pkcs11_module = pkcs11_module
        self.cert_id = cert_id
        self.pin = pin

    def insert_certificate(self, certificate_path, slot, cert_label):
        self.logger.info("-insert certificate")
        self.logger.info("--cert id: {}; cert label: {}".format(self.cert_id, cert_label))
        subprocess.call(['bash', 'insert_cert.sh',
                         '--certificate_path', certificate_path,
                         '--hsm_slot', slot,
                         '--hsm_pin', self.pin,
                         '--id', self.cert_id,
                         '--label', cert_label])

    def export_certificate(self, output_file):
        self.logger.info("-export certificate")
        self.logger.info("--cert id: {}".format(self.cert_id))
        self.logger.info("--output file: {}".format(output_file))

        cmd = ['bash', 'export_cert.sh',
               '--module', self.pkcs11_module,
               '--id', self.cert_id,
               '--output_file', output_file,
               '--pin', self.pin]
        subprocess.call(cmd)


def import_certificate():
    insert_cert = CertHandler(
        pin = "1234",
        cert_id = 5,
    )
    insert_cert.insert_certificate(slot=0,
                                   cert_label="test",
                                   certificate_path="/home/admin/certs/test.pem")

def export_certificate():
    export_cert = CertHandler(
        pin = "1234",
        cert_id = 5,
    )
    export_cert.export_certificate(output_file="/home/admin/certs/test.pem")

if __name__ == "__main__":
    import_certificate()
