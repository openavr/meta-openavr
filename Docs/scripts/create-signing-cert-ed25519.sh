#!/bin/bash
#
# Example script for creating a certificate for signing files to verify their
# authenticity before a device loads them.
#
# References:
#
# * https://gist.github.com/selftaught/cfa67d188a2fdb1f4cc675395654cfcf
# * man genpkey
#

set -e
set -x

#
# generate a signing key
#

openssl genpkey -algorithm Ed25519 -out privatekey.pem
openssl pkey -in privatekey.pem -pubout -out publickey.pem

#
# sign a file
#
# This does not work with the DGST command. Need to use the pkeyutl command to
# sign/verify with ed25519 keys an that was introduced in openssl-3.0.0.
#

cat >test-file.txt <<EOF
This is a file we want to sign.
EOF

# Fails!
openssl dgst -sha256 -sign privatekey.pem -out test-file.sign test-file.txt

#
# Verify it
#

# Fails!
openssl dgst -sha256 publickey.pem -signature test-file.sign test-file.txt

# This will work with openssl-3.0.x
openssl pkeyutl -verify -pubin -inkey ed25519_pub.pem -sigfile \
    file.zip.ed25519.sig -rawin -in file.zip
