#!/bin/sh

# instructions came from
# https://jitsusamablog.wordpress.com/2016/08/03/self-signed-certificates-in-ios-simulator/
# https://blog.kloud.com.au/2016/06/12/creating-openssl-self-signed-certs-on-windows/

# create our CA private key
openssl genrsa -out ca.key 2048

# use this key to encrypt a new CA certificate file
openssl req -x509 -new -nodes -key ca.key -sha256 -days 512 -out ca.crt \
  -subj "/C=NZ/ST=Otago/L=Alexandra/O=Peaksoft/CN=Peaksoft CA"

# Pacakge your public and private key in a pkcs12 encripted file (to install with certmgr on windows)
## ref> https://www.openssl.org/docs/manmaster/apps/pkcs12.html<Paste>
openssl pkcs12 -export -inkey ca.key -in ca.crt -out ca.pfx

