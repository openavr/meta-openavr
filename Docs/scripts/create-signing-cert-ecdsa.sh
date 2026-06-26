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

openssl genpkey -algorithm EC \
    -pkeyopt ec_paramgen_curve:P-256 \
    -pkeyopt ec_param_enc:named_curve | \
  openssl pkcs8 -topk8 -nocrypt -outform pem > privatekey.pem

openssl pkey -pubout -inform pem -outform pem \
    -in privatekey.pem \
    -out publickey.pem

#
# sign a file
#

FNAME="test-file.txt"

cat >test-file.txt <<EOF
This is a file we want to sign.
EOF

#
# Create signature:
openssl dgst -sha256 -sign privatekey.pem ${FNAME} > ${FNAME}.sign

#
# Verify signature:
openssl dgst -sha256 -verify publickey.pem -signature ${FNAME}.sign ${FNAME}
