#!/bin/sh

openssl req -x509 -new -nodes -key ca.key -sha256 -days 512 -out ca.crt \
  -subj "/C=NZ/ST=Otago/L=Alexandra/O=Peaksoft/CN=Peaksoft CA"


