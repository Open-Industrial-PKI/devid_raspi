import requests
import OpenSSL.crypto as crypto
import logger


class CertValidator:
    def __init__(self):
        self.logger = logger.get_logger("CertValidator")
        self.ca_certs = None

    def _load_ca_certs_via_public_web(self, ca_chain_url):
        self.logger.info("-load CA chain via public web interface")
        response = requests.get(ca_chain_url, verify=False)
        ca_chain = response.content.decode("utf-8")
        certs = ca_chain.split("-----BEGIN CERTIFICATE-----\n")[1:]
        certs = ["-----BEGIN CERTIFICATE-----\n" + cert for cert in certs]
        self.ca_certs = [crypto.load_certificate(crypto.FILETYPE_PEM, cert) for cert in certs]

    def _load_ca_certs_via_local_storage(self, ca_chain_path):
        self.logger.info("-load CA chain via local storage")
        # Load the CA chain from a file
        with open(ca_chain_path, 'rb') as f:
            ca_chain = f.read()

        self.ca_certs = [crypto.load_certificate(crypto.FILETYPE_PEM, cert) for cert in ca_chain]

    def validate(self, cert_path):
        self.logger.info("-validate certificate against chain")
        self.logger.info("--certificate: {}".format(cert_path))
        with open(cert_path, "rb") as f:
            cert_data = f.read()
        cert = crypto.load_certificate(crypto.FILETYPE_PEM, cert_data)
        store = crypto.X509Store()
        for ca_cert in self.ca_certs:
            store.add_cert(ca_cert)
        store_ctx = crypto.X509StoreContext(store, cert)
        try:
            store_ctx.verify_certificate()
            self.logger.info("-- ✅ certificate is valid")
            return True
        except crypto.X509StoreContextError as e:
            self.logger.info("-- ❌ certificate is NOT valid")
            self.logger.error(str(e))
            return False

def validate_cert_via_public_web(ca_chain_url, cert_path):
    public_web_validator = CertValidator()
    public_web_validator._load_ca_certs_via_public_web(ca_chain_url)
    public_web_validator.validate(cert_path)

if __name__ == "__main__":
    ca_chain_url = "https://campuspki.germanywestcentral.cloudapp.azure.com/ejbca/publicweb/webdist/certdist?cmd=cachain&caid=-1791256346&format=pem"
    cert_path = "/home/admin/certs/crt.pem"
    validate_cert_via_public_web(ca_chain_url, cert_path)