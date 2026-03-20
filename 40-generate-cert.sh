#!/bin/sh

set -e

openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/${CERT_NAME}.key -out /etc/nginx/${CERT_NAME}.pem -days 30 -nodes -subj '/CN=localhost'
# Cert valid for 30 days