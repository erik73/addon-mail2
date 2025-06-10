#!/bin/sh

# Generates a self-signed certificate.
# Edit dovecot-openssl.cnf before running this.

umask 077
OPENSSL=${OPENSSL-openssl}
SSLDIR=${SSLDIR-/etc/ssl/dovecot}
OPENSSLCONFIG=${OPENSSLCONFIG-dovecot-openssl.cnf}

CERTDIR=$SSLDIR


CERTFILE=$CERTDIR/server.pem
KEYFILE=$CERTDIR/server.key

if [ ! -d "$CERTDIR" ]; then
  echo "$CERTDIR directory doesn't exist"
  exit 1
fi

if [ -f "$CERTFILE" ]; then
  echo "$CERTFILE already exists, won't overwrite"
  exit 1
fi

if [ -f "$KEYFILE" ]; then
  echo "$KEYFILE already exists, won't overwrite"
  exit 1
fi

$OPENSSL req -new -x509 -nodes -config "$OPENSSLCONFIG" -out "$CERTFILE" -keyout $KEYFILE -days 365 || exit 2
chmod 0600 "$KEYFILE"
echo 
$OPENSSL x509 -subject -fingerprint -noout -in "$CERTFILE" || exit 2