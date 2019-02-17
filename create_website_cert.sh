#!/bin/sh

# instructions came from
# https://jitsusamablog.wordpress.com/2016/08/03/self-signed-certificates-in-ios-simulator/
# https://blog.kloud.com.au/2016/06/12/creating-openssl-self-signed-certs-on-windows/

# create the key for a localhost server
openssl genrsa -out dev.safely.local.key 2048

# Using this key, we next sign a CSR (Certificate Signing Request)
openssl req -new -key dev.safely.local.key -out dev.safely.local.csr \
  -subj "/C=NZ/ST=Otago/L=Alexandra/O=Peaksoft/CN=dev.safely.local"

# sign this CSR with your newly created CA
openssl x509 -req -days 500 -sha256 -in dev.safely.local.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial -out dev.safely.local.crt

# Package your public and private key in a pkcs12 encripted file (to install with certmgr on
# windows)
# ref> https://www.openssl.org/docs/manmaster/apps/pkcs12.html
openssl pkcs12 -export -inkey dev.safely.local.key -in dev.safely.local.crt -out dev.safely.local.pfx


