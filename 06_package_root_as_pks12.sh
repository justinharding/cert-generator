#!/bin/sh

openssl pkcs12 -export -inkey ca.key -in ca.crt -out ca.pfx

