#!/bin/sh

openssl req -new -key dev.safely.local.key -out dev.safely.local.csr \
  -subj "/C=NZ/ST=Otago/L=Alexandra/O=Peaksoft/CN=dev.safely.local"
