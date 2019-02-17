#!/bin/sh

# instructions came from
# https://jitsusamablog.wordpress.com/2016/08/03/self-signed-certificates-in-ios-simulator/
# https://blog.kloud.com.au/2016/06/12/creating-openssl-self-signed-certs-on-windows/

usage() {
  cat <<-END
    Create a certificate authority to use for generating certificates
    optionally create a windows pfx file for iis

    Usage: $0 -a certificate authority name -c country code -s state -t town/city [-w]
    e.g. $0 -a MyAuthority -c NZ -s Otago -t Alexandra -w

    country, state and town are used for the certificate
    -w  generate windows pfx file for iis. You will be prompted for a password to protect the file
END
  exit 1;
}

generate_pfx=false
country="NZ"
state="Otago"
city="Alexandra"

while getopts ":wa:c:s:t:" o; do
  case "${o}" in
    a)
      authority=${OPTARG}
      ;;
    c)
      country=${OPTARG}
      ;;
    s)
      state=${OPTARG}
      ;;
    t)
      city=${OPTARG}
      ;;
    w)
      generate_pfx=true
      ;;
    *)
      usage
      ;;
  esac
done

if [ -z "${authority}" ]; then
  cat <<-END
    you must specify an authority

END
  usage
fi

lower_authority=$(echo $authority | awk '{print tolower($0)}')

echo "creating CA private key into ${lower_authority}.key"
openssl genrsa -out ${lower_authority}.key 2048

echo "using new key to encrypt new CA certificate file ${lower_authority}.crt"
openssl req -x509 -new -nodes -key ${lower_authority}.key -sha256 -days 512 -out ${lower_authority}.crt \
  -subj "/C=${country}/ST=${state}/L=${city}/O=${authority}/CN=${authority} CA"

if $generate_pfx; then
  echo "packaging public and private key in pkcs12 encrypted file ${lower_authority}.pfx (to install with certmgr on windows)"
  ## ref> https://www.openssl.org/docs/manmaster/apps/pkcs12.html<Paste>
  openssl pkcs12 -export -inkey ${lower_authority}.key -in ${lower_authority}.crt -out ${lower_authority}.pfx
fi

