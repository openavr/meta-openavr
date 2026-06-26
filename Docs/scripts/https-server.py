#!/usr/bin/env python3
#
# To create the server certificate:
#
#   $ openssl req -new -x509 \
#       -keyout server-crt.pem \
#       -out server-crt.pem \
#       -days 365 -nodes \
#       -subj '/CN=localhost/O=StudioAsyncAPI/C=TR'
#
# View the server certificate:
#
#   $ openssl x509 -text -in server-crt.pem
#

import http.server
import socketserver
import ssl
import logging

server_host = 'devcfg.openavr.org'
server_port = 443
ssl_key_path = './ee-devcfg-openavr-org.key'
ssl_cert_path = './ee-devcfg-openavr-org.crt'

DIRECTORY = './devcfg-doc-root'

logging.basicConfig(level=logging.INFO)


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=DIRECTORY, **kwargs)


logging.info('Server running... https://{}:{}'.format(server_host, server_port))

with socketserver.TCPServer((server_host, server_port), Handler) as httpd:
    httpd.socket = ssl.wrap_socket(
            httpd.socket,
            keyfile=ssl_key_path,
            certfile=ssl_cert_path,
            server_side=True,
        )

    httpd.serve_forever()
