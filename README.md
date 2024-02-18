# 3BD (Three Blind Deeds)
Welcome to 3 Blind Deeds a new way to borrow against your onchain assets without revealing your assets preserving your privacy.
This protocol enables you to create an onchain deed which can be collateralised on chain on the 3BD Lending Big Board without revealing the
assets held by the deed. The 3BD protocol also makes lending more efficient by reducing the amount of information required to lend, as Lenders 
are provided with on chain proof that a deed is above a given value and hence can make offers appropriate to their risk tolerance. 

**so what?**
This means that now borrowers can collaterallize and DeFi previously non-DeFi-able assets, opening the market for DeFi lending by several orders of magnitude and simplifying the lending process for complex asset classes. 

**so how does it work?** 
3BD enables you to created an Blind on chain deed. An on chain deed is a smart contract where you have transferred ownership of your assets e.g. 
NFTs, Cryptocurrency, Tokenized Real World Assets (RWA) etc, to the deed, hence whoever holds the deed holds (and can dispose of) your assets. 
Further to this the deed contract allows potential lenders (i.e. not owners) to value the contents of the deed against a particular value 
without revealing the actual total value of the deed nor it's contents. The deed only provides an on chain insight into it's numercial 
composition i.e. percentages of how many NFTs, how much cryptocurrency etc is held. Lenders can then lend against this information secure in the 
knowledge that in the case of default or collateral devaluation they will be able to quickly and readily recover their loses  from whatever 
assets are behind the deed.


## Deployed Contracts
All contracts are deployed on the Scroll Sepolia testnet. Only "Front end" i.e. user interacting (& non-derivative) contracts have been verified. 
|Name|Contract | Address | Version |
|----|---------|---------|---------|
|RESERVED_ZK_REGISTER|ZKRegister.sol| [0xC2A808664B1287503ca5FFB6eAACea27c508b495] (https://sepolia.scrollscan.dev/address/0xC2A808664B1287503ca5FFB6eAACea27c508b495#code)|
|RESERVED_ZK_ADMIN|N/A|[0x308767913dFeB43649E74276Ee9434687d73813F](https://sepolia.scrollscan.dev/address/0x308767913dFeB43649E74276Ee9434687d73813F)|0|
|RESERVED_ZK_DEED_CONTRACT||[0xab4F0E2D17Ea0aA60fE18E758661E0031F45aB34](https://sepolia.scrollscan.dev/address/0xab4F0E2D17Ea0aA60fE18E758661E0031F45aB34)|2|
|RESERVED_ORACLE_DIRECTORY||[0x70705F499bedd9117d265839AF5E26BA5BdAC886](https://sepolia.scrollscan.dev/address/0x70705F499bedd9117d265839AF5E26BA5BdAC886)|3|
|RESERVED_CHAIN_LINK_ORACLE||[0xc581878B57437b734837d88629539c2cD3cBc696](https://sepolia.scrollscan.dev/address/0xc581878B57437b734837d88629539c2cD3cBc696)|1|
|RESERVED_ZK_ORACLE||[0xEE18Ebd9d89dd9Dff6D5483c515c10F5b9b44ad8](https://sepolia.scrollscan.dev/address/0xEE18Ebd9d89dd9Dff6D5483c515c10F5b9b44ad8)|1|
