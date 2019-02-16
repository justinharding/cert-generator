#!/bin/sh

openssl x509 -req -days 500 -sha256 -in dev.safely.local.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial -out dev.safely.local.crt
