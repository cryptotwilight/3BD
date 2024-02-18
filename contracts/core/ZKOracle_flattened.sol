// SPDX-License-Identifier: GPL-3.0
// File: contracts/interfaces/oracle/IOracleDirectory.sol



pragma solidity >=0.8.2 <0.9.0;

interface IOracleDirectory { 

    function isSupported(string memory _symbol, string memory _quote) view external returns (bool _isSupported);

    function isSupported(address _nftContract, string memory _quote) view external returns (bool _isSupported);

    function getOracle(string memory _symbol, string memory _quote) view external returns (address _oracle);

    function getOracle(address _nftContract, string memory _quote) view external returns (address _oracle);

}
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
// File: contracts/interfaces/IZKOracle.sol



pragma solidity >=0.8.2 <0.9.0;


interface IZKOracle { 

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price);

    function getFloorPrice(address _nft, string memory _quote)  view external returns (uint256 _floorPrice);

}
// File: contracts/interfaces/IZKVersion.sol



pragma solidity >=0.8.2 <0.9.0;


interface IZKVersion { 

    function getName() view external returns (string memory _name);

    function getVersion() view external returns (uint256 _version);

}
// File: contracts/core/ZKOracle.sol



pragma solidity >=0.8.2 <0.9.0;







contract ZKOracle is IZKOracle, IZKVersion {

    string constant name = "RESERVED_ZK_ORACLE"; 
    uint256 constant version = 1; 
    address immutable self; 

    string constant ORACLE_DIRECTORY = "RESERVED_ORACLE_DIRECTORY";


    IZKRegister register; 

    constructor(address _register){
        register = IZKRegister(_register);
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price){
        IOracleDirectory directory_ = IOracleDirectory(register.getAddress(ORACLE_DIRECTORY));
        ICryptoOracle oracle_ = ICryptoOracle(directory_.getOracle(_base, _quote));
        return oracle_.getPrice(_base, _quote);
    }

    function getFloorPrice(address _nft, string memory _quote)  view external returns (uint256 _floorPrice){
        IOracleDirectory directory_ = IOracleDirectory(register.getAddress(ORACLE_DIRECTORY));
        INFTOracle oracle_ = INFTOracle(directory_.getOracle(_nft, _quote));
        return oracle_.getFloorPrice(_nft, _quote);
    }


}