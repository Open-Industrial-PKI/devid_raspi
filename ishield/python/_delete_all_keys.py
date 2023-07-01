from hsm_objects import HsmObjects


def main():
    hsm_objects = HsmObjects(
        slot_num=0,
        pin='1234'
    )
    hsm_objects.delete_all_keys()

if __name__ == "__main__":
    main()