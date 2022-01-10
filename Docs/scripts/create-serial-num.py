#!/usr/bin/env python3

import sys
import uuid
import hashlib

DIGEST_SIZE=4  # in bytes

def main():
    hwid = sys.argv[1]

    h = hashlib.blake2s(digest_size=DIGEST_SIZE)
    h.update(hwid.encode())
    print(f'HWID: {hwid} -> {h.hexdigest()}')

    dev_uuid = uuid.uuid5(uuid.NAMESPACE_DNS, hwid)
    h = hashlib.blake2s(digest_size=DIGEST_SIZE)
    h.update(str(dev_uuid).encode())
    print(f'HWID: {hwid} -> UUID: {dev_uuid} -> {h.hexdigest()}')


if __name__ == '__main__':
    main()
