#!/bin/sh

# instructions came from
# https://jitsusamablog.wordpress.com/2016/08/03/self-signed-certificates-in-ios-simulator/
# https://blog.kloud.com.au/2016/06/12/creating-openssl-self-signed-certs-on-windows/

usage() {
  cat <<-END
    Create a certificate suitable for a website using specified certificate authority
    optionally create a windows pfx file for iis

    Usage: $0 -a certificate authority name -u website url -c country code -s state -t town/city [-w]
    e.g. $0 -a MyAuthority -u dev.safely.local -c NZ -s Otago -t Alexandra -w

    country, state and town are used for the certificate
    -w  generate windows pfx file for iis. You will be prompted for a password to protect the file
END
  exit 1;
}

generate_pfx=false
country="NZ"
state="Otago"
city="Alexandra"

while getopts ":wa:u:c:s:t:" o; do
  case "${o}" in
    a)
      authority=${OPTARG}
      ;;
    u)
      url=${OPTARG}
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

if [ -z "${url}" ]; then
  cat <<-END
    you must specify a url

END
  usage
fi

lower_authority=$(echo $authority | awk '{print tolower($0)}')

if [ ! -f ${lower_authority}.crt ]; then
  cat <<-END
    CA file ${lower_authority}.crt not found
    you need to find the CA files or generate a new CA

END
usage
fi

if [ ! -f ${lower_authority}.key ]; then
  cat <<-END
    CA file ${lower_authority}.key not found
    you need to find the CA files or generate a new CA

END
  usage
fi

echo "creating key for ${url} into ${url}.key"
openssl genrsa -out ${url}.key 2048

echo "using new key to sign CSR (Certificate Signing Request) ${url}.key"
openssl req -new -key ${url}.key -out ${url}.csr \
  -subj "/C=${country}/ST=${state}/L=${city}/O=${authority}/CN=${url}"

echo "signing CSR with CA ${lower_authority}.crt and {$lower_authority}.key into ${url}.crt"
openssl x509 -req -days 500 -sha256 -in ${url}.csr \
  -CA ${lower_authority}.crt -CAkey ${lower_authority}.key -CAcreateserial -out ${url}.crt

if $generate_pfx; then
  echo "packaging public and private key in pkcs12 encrypted file ${url}.pfx (to install with certmgr)"
  # ref> https://www.openssl.org/docs/manmaster/apps/pkcs12.html
  openssl pkcs12 -export -inkey ${url}.key -in ${url}.crt -out ${url}.pfx
fi

