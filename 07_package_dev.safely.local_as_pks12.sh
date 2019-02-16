#!/bin/sh

openssl pkcs12 -export -inkey dev.safely.local.key -in dev.safely.local.crt -out dev.safely.local.pfx

