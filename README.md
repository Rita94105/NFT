## NFT Foundry test
```
git clone --recurse-submodules https://github.com/Rita94105/NFT.git
cd NFT
forge test --match-contract Receiver
forge test --match-contract MyToken
```

### Installing openzeppelin and chainlink in Foundry

```
forge install openzeppelin/openzeppelin-contracts --no-commit
forge install smartcontractkit/chainlink --no-commit;
```
