// SPDX-License-Identifier: GPL-3.0
// File: contracts/interfaces/oracle/IOracleStructs.sol



pragma solidity >=0.8.2 <0.9.0;


struct Pair {
    string base; 
    string quote; 
}

struct NFT { 
    address nftContract; 
    string quote; 
}

struct CryptoOracle { 
    string name; 
    address oracleAddress; 
    Pair [] pairs; 
}

struct NFTOracle {
    string name; 
    address oracleAddress; 
    NFT [] nfts; 
}
// File: contracts/interfaces/oracle/INFTOracle.sol



pragma solidity >=0.8.2 <0.9.0;


interface INFTOracle { 

    function getSupports() view external returns (NFTOracle memory _oracle);

    function getFloorPrice(address _nftContact, string memory _quoteSymbol) view external returns (uint256 _price); 

}
// File: contracts/interfaces/oracle/ICryptoOracle.sol



pragma solidity >=0.8.2 <0.9.0;


interface ICryptoOracle { 

    function getSupports() view external returns (CryptoOracle memory _oracle);

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price);
}
// File: contracts/interfaces/oracle/IOracleDirectory.sol



pragma solidity >=0.8.2 <0.9.0;

interface IOracleDirectory { 

    function isSupported(string memory _symbol, string memory _quote) view external returns (bool _isSupported);

    function isSupported(address _nftContract, string memory _quote) view external returns (bool _isSupported);

    function getOracle(string memory _symbol, string memory _quote) view external returns (address _oracle);

    function getOracle(address _nftContract, string memory _quote) view external returns (address _oracle);

}
// File: contracts/interfaces/IZKDStructs.sol



pragma solidity >=0.8.2 <0.9.0;

enum TxType {DEED_DEPOSIT, DEED_WITHDRAW, BORROW, REPAY}

struct TX { 
    uint256 id; 
    address deedContract;
    uint256 deedId; 
    uint256 amount; 
    address currency; 
    TxType txType; 
}

struct Burn {
    uint256 id; 
    uint256 amount; 
    uint256 burnDate; 
}

struct ZKProof { 
    address prover; 
    address denomination; 
    string proof; 
    uint256 amount; 
    address erc20; 
    uint256 createDate; 
}

struct ZKComposition { 

    uint256 erc20; 
    uint256 erc721; 
    uint256 erc1155; 
}

struct Asset {
    uint256 id;  
    AssetType aType; 
    address assetContract; 
    uint256 amount; 
    uint256 assetContractId; 
}

enum AssetType {ERC20, ERC721, ERC1155}

struct Config { 
    string name; 
    address addr; 
    uint256 version; 
}
// File: contracts/interfaces/IZKRegister.sol



pragma solidity >=0.8.2 <0.9.0;


interface IZKRegister { 

    function isKnownName(string memory _name)view external returns (bool _isKnownName);

    function isKnownAddress(address _address) view external returns (bool _isKnownAddress);

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

    function getConfig() view external returns (Config [] memory _configuration);

    function getUINTValue(string memory _name) view external returns (uint256 _value);

}
// File: contracts/interfaces/IZKVersion.sol



pragma solidity >=0.8.2 <0.9.0;


interface IZKVersion { 

    function getName() view external returns (string memory _name);

    function getVersion() view external returns (uint256 _version);

}
// File: contracts/core/oracle/OracleDirectory.sol



pragma solidity >=0.8.2 <0.9.0;








contract OracleDirectory is IOracleDirectory, IZKVersion { 

    modifier adminOnly { 
        require(msg.sender == register.getAddress(ZK_ADMIN), "admin only");
        _; 
    }

    string constant name = "RESERVED_ORACLE_DIRECTORY";
    uint256 constant version = 3; 

    string constant ZK_ADMIN = "RESERVED_ZK_ADMIN";

    mapping(string=>mapping(string=>bool)) isSupportedByBaseByQuote; 
    mapping(string=>mapping(address=>bool)) isSupportedByNFTContractByQuote; 
    mapping(string=>mapping(string=>address[])) oracleByBaseByQuote; 
    mapping(string=>mapping(address=>address[])) oracleByNFTContractByQuote; 

    string [] oracleNames; 

    IZKRegister register; 

    constructor(address _register) {
        register = IZKRegister(_register);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getOracleNames() view external returns (string [] memory _names) {
        return oracleNames; 
    }

    function isSupported(string memory _base, string memory _quote) view external returns (bool _isSupported) {
        return isSupportedByBaseByQuote[_quote][_base];
    }

    function isSupported(address _nftContract, string memory _quote) view external returns (bool _isSupported) {
        return isSupportedByNFTContractByQuote[_quote][_nftContract];
    }

    function getOracle(string memory _base, string memory _quote) view external returns (address _oracle) {
        require(isSupportedByBaseByQuote[_quote][_base], "symbol not supported");
        return oracleByBaseByQuote[_quote][_base][0];
    }

    function getOracle(address _nftContract, string memory _quote) view external returns (address _oracle) {
        require(isSupportedByNFTContractByQuote[_quote][_nftContract], "contract & quote not supported" );
        return oracleByNFTContractByQuote[_quote][_nftContract][0];
    }

    function registerCryptoOracle(address _oracle) external adminOnly returns (bool _added) { 
        return addCyptoOracleInternal(ICryptoOracle(_oracle).getSupports());
        
    }

    function registerNFTOracle(address _oracle) external adminOnly returns (bool added) {
        return addNFTOracleInternal(INFTOracle(_oracle).getSupports()); 
    }


    //==================================== INTERNAL =============================================

    function addCyptoOracleInternal(CryptoOracle memory _oracle) internal returns (bool _added){
        for(uint256 x = 0; x < _oracle.pairs.length; x++) {
            Pair memory pair_ = _oracle.pairs[x];
            oracleByBaseByQuote[pair_.quote][pair_.base].push(_oracle.oracleAddress); 
            isSupportedByBaseByQuote[pair_.quote][pair_.base] = true; 
        }
        oracleNames.push(_oracle.name);
        return true; 
    }

    function addNFTOracleInternal(NFTOracle memory _oracle) internal returns (bool _added) {
        for(uint256 x = 0; x < _oracle.nfts.length; x++) {
            NFT memory nft_ = _oracle.nfts[x];
            isSupportedByNFTContractByQuote[nft_.quote][nft_.nftContract] = true; 
            oracleByNFTContractByQuote[nft_.quote][nft_.nftContract].push(_oracle.oracleAddress);
        }
        return true; 
    }

}