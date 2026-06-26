#!/bin/bash

LOCAL_CERT_DIR="/usr/local/share/ca-certificates"
TMP_CERT_DIR="$(mktemp -d --tmpdir devcfg-ca-certs-XXXXXXXXXXXXXXXXX)"
ROOT_CERT="${LOCAL_CERT_DIR}/OpenAVR-Root-CA.crt"

# TODO: Remove TMP_CERT_DIR via a trap

set -x

cp ${LOCAL_CERT_DIR}/OpenAVR*.crt ${TMP_CERT_DIR}

openssl rehash ${TMP_CERT_DIR}

# We want curl to only use the OpenAVR self signed root CA certs so as to
# validate that the devcfg server is truely our server. The following curl
# command will fail if the server's cert is not signed by the OpenAVR root
# CA or one of the intermediate OpenAVR CA's.
curl -v --cacert ${ROOT_CERT} --capath ${TMP_CERT_DIR} \
    https://devcfg.openavr.org/  # || exit 1

# TODO: Move this to a trap on exit
rm -rf ${TMP_CERT_DIR}
