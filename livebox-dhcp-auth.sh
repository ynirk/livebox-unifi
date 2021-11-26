#!/usr/bin/env bash

# ref https://lafibre.info/remplacer-livebox/cacking-nouveau-systeme-de-generation-de-loption-90-dhcp/
# Option (90) Authentication:
# 11 null bytes:
#   - 1 for the authentication protocol: 0 means "configuration token"
#   - 1 for the algorithm: 0 means "none"
#   - 1 for RDM (Replay Detection method) type: 0 means "monotonically-increasing counter"
#   - 8 for RDM (Replay Detection method) value (here, 0, simply)
# Then a sequence of Type-Length-Value fields:
#   - Unknown field: type 0x1A, length 9 (1+1+7), value 00:00:05:58:01:03:41
#   - Username field: type 0x01, length 13 (1+1+11), our Orange PPP login, i.e. "fti/xxxxxxx"
#   - Salt field: type 0x3C, length 18 (1+1+16), 16-byte random salt
#   - Hash field: type 0x03, length 19 (1+1+17), 1 random byte followed by the 16-byte MD5 hash of:
#     - that random byte
#     - Orange PPP password
#     - the salt field

usage() {
  cat <<EOF 1>&2
Usage: $0 <connexion id> <password>
  connexion id  - connexion id fti/xxxxx
  passsowrd     - connexion password
EOF

  exit 1;
}

to_hex() {
  echo -n $1 | xxd -pu | sed 's/\(..\)/\1:/g;s/:$//'
}

if [ $# -ne 2 ]; then usage; fi

SALT=$(openssl rand -hex 8)
BYTE=$(openssl rand -hex 1 | cut -c1)
MD5=$(echo -n $BYTE$2$SALT | md5sum | awk '{print $1}' | sed 's/\(..\)/\1:/g;s/:$//')

echo "00:00:00:00:00:00:00:00:00:00:00:1a:09:00:00:05:58:01:03:41:01:0d:$(to_hex $1):3c:12:$(to_hex $SALT):03:13:$(to_hex $BYTE):$MD5"
