# Create a CSV script that would lock funds until one hundred and fifty blocks had passed
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277


blocks=150
public_key="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"


OP_CHECKSEQUENCEVERIFY="b2"
OP_DROP="75"
OP_DUP="76"
OP_HASH160="a9"
PUBKEY_HASH_PUSH="14" 
OP_EQUALVERIFY="88"
OP_CHECKSIG="ac"


BLOCKS_HEX=$(printf '%08x\n' $blocks | sed 's/^\(00\)*//')


HEX_FIRST_CHAR=$(echo $BLOCKS_HEX | cut -c1)
[[ 0x$HEX_FIRST_CHAR -gt 0x7 ]] && BLOCKS_HEX="00"$BLOCKS_HEX


BLOCKS_LE_HEX=$(echo $BLOCKS_HEX | grep -o .. | tac | tr -d '\n')

BLOCKS_BYTES=$(echo -n "$BLOCKS_LE_HEX" | wc -c | awk '{print $1/2}')
BLOCKS_PUSH=$(printf "%02x" $BLOCKS_BYTES)


PUBKEY_HASH=$(echo -n "$public_key" | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 -binary | xxd -p)


SCRIPT_HEX="${BLOCKS_PUSH}${BLOCKS_LE_HEX}${OP_CHECKSEQUENCEVERIFY}${OP_DROP}${OP_DUP}${OP_HASH160}${PUBKEY_HASH_PUSH}${PUBKEY_HASH}${OP_EQUALVERIFY}${OP_CHECKSIG}"

echo "$SCRIPT_HEX"
