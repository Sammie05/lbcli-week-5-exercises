# Create a CLTV script with a timestamp of 1495584032 and public key below:
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

publicKey="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"

timestamp=1495584032

OP_CHECKLOCKTIMEVERIFY="b1"
OP_DROP="75"
OP_DUP="76"
OP_HASH160="a9"
PUBKEY_HASH_PUSH="14" 
OP_EQUALVERIFY="88"
OP_CHECKSIG="ac"


TIMESTAMP_HEX=$(printf '%08x\n' $timestamp | sed 's/^\(00\)*//')


HEX_FIRST_CHAR=$(echo $TIMESTAMP_HEX | cut -c1)
[[ 0x$HEX_FIRST_CHAR -gt 0x7 ]] && TIMESTAMP_HEX="00"$TIMESTAMP_HEX


TIMESTAMP_LE_HEX=$(echo $TIMESTAMP_HEX | grep -o .. | tac | tr -d '\n')


TIMESTAMP_BYTES=$(echo -n "$TIMESTAMP_LE_HEX" | wc -c | awk '{print $1/2}')
TIMESTAMP_PUSH=$(printf "%02x" $TIMESTAMP_BYTES)


PUBKEY_HASH=$(echo -n "$publicKey" | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 -binary | xxd -p)

SCRIPT_HEX="${TIMESTAMP_PUSH}${TIMESTAMP_LE_HEX}${OP_CHECKLOCKTIMEVERIFY}${OP_DROP}${OP_DUP}${OP_HASH160}${PUBKEY_HASH_PUSH}${PUBKEY_HASH}${OP_EQUALVERIFY}${OP_CHECKSIG}"

echo "$SCRIPT_HEX"