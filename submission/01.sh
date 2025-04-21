# Create a wallet with the name "btrustwallet".
wallet=$(bitcoin-cli -regtest createwallet "btrustwallet" | jq .name)

echo "$wallet"
