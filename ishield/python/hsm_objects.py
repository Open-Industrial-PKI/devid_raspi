import re
import json
import subprocess

class HsmObjects:
    def __init__(self, slot_num, pin):
        self.private_keys = {}
        self.public_keys = {}
        self.certificates = {}
        self.slot_num = slot_num
        self.pin = pin
        objects = self.list_objects_on_hsm()
        self.parse_input_str(objects)

    def list_objects_on_hsm(self):
        # Run the bash script and capture the output
        result = subprocess.check_output(["./bash/list_objects.sh",  str(self.slot_num), self.pin])
        result_str = result.decode('utf-8')  # decode bytes object to string
        return result_str

    def parse_input_str(self, input_str):
        pattern = r'^\s*([^:]+):\s*(.*?)\s*$'

        current_obj_type = None
        current_obj_label = None
        current_obj_id = None
        current_obj_usage = None
        current_obj_access = None
        current_obj_subject = None

        for line in input_str.split('\n'):
            match = re.match(r"(Certificate|Public|Private)\s(Key|Object)", line)
            if match:
                current_obj_type = match.group(1).lower()
                current_obj_label = None
                continue

            match = re.match(pattern, line)
            if match:
                key = match.group(1)
                value = match.group(2)
                if key == 'label':
                    current_obj_label = value
                elif key == 'ID':
                    current_obj_id = value
                elif key == 'Usage':
                    current_obj_usage = value
                elif key == 'Access':
                    current_obj_access = value
                elif key == 'subject':
                    current_obj_subject = value

                if current_obj_label and current_obj_id and current_obj_usage and current_obj_access:

                    obj_data = {}

                    if current_obj_id:
                        obj_data['ID'] = current_obj_id
                    if current_obj_usage:
                        obj_data['Usage'] = current_obj_usage
                    if current_obj_access:
                        obj_data['Access'] = current_obj_access
                    if current_obj_subject:
                        obj_data['Subject'] = current_obj_subject

                    if current_obj_type == 'private':
                        self.private_keys[current_obj_label] = obj_data
                    elif current_obj_type == 'public':
                        self.public_keys[current_obj_label] = obj_data
                    elif current_obj_type == 'certificate':
                        self.certificates[current_obj_label] = obj_data

                    current_obj_label = None
                    current_obj_id = None
                    current_obj_usage = None
                    current_obj_access = None
                    current_obj_subject = None

    def to_dict(self):
        return {
            'private_keys': self.private_keys,
            'public_keys': self.public_keys,
            'certificates': self.certificates
        }

    def to_json(self):
        return json.dumps(self.to_dict(), indent=4)

    def filter_id_by_label(self, key_label):
        keys = self.to_json()
        keys_str = json.loads(keys)
        for key_type in ["private_keys", "public_keys"]:
            if key_label in keys_str[key_type]:
                return keys_str[key_type][key_label]["ID"]

    def delete_all_keys(self):
        keys = self.to_dict()
        self.delete_keys(keys)


    def delete_ldev_keys(self):
        self.delete_key_by_type("ldev")


    def delete_idev_keys(self):
        self.delete_key_by_type("idev")

    def delete_key_by_type(self, type):
        keys = self.to_dict()
        filtered_dict = {k1: {k2: v2 for k2, v2 in v1.items() if k2.startswith(type)} for k1, v1 in keys.items()}
        self.delete_keys(filtered_dict)

    def delete_keys(self, keys):
        for key_type in keys:
            priv_pub_key = "priv" if key_type == "private_keys" else "pub"
            for key_name in keys[key_type]:
                key_data = keys[key_type][key_name]
                self.delete_key(priv_pub_key, key_data['ID'])

    def delete_key_by_label(self, key_label):
        self.filter_id_by_label(key_label)

    def delete_key(self, priv_pub_key, key_id):
        command = ['./bash/delete_keys_on_hsm.sh', "--key_type", priv_pub_key, "--id", key_id, "--pin", self.pin]
        print("Executing command:", " ".join(command))
        subprocess.call(command)



def main():
    print("--- Print Objects ---")
    hsm_objects = HsmObjects(
        slot_num=0,
        pin='1234'
    )
    print(hsm_objects.to_dict())
    print(hsm_objects.to_json())
    #print(hsm_objects.to_dict())
    print("--- Get key ID ---")
    print("ID: {}".format(hsm_objects.filter_id_by_label(key_label="my_rsa_pvt_86599")))

def delete_idev():
    hsm_objects = HsmObjects(
        slot_num=0,
        pin='1234'
    )
    hsm_objects.delete_idev_keys()

if __name__ == "__main__":
    delete_idev()
