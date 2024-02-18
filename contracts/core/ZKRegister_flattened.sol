// SPDX-License-Identifier: GPL-3.0

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
// File: contracts/core/ZKRegister.sol



pragma solidity >=0.8.2 <0.9.0;



contract ZKRegister is IZKRegister, IZKVersion { 


    modifier adminOnly {
        require(msg.sender == admin, "admin only");
        _;
    }

    string constant name = "RESERVED_ZK_REGISTER";
    uint256 constant version = 3; 

    string constant ZK_ADMIN = "RESERVED_ZK_ADMIN";

    address immutable self; 

    address admin; 

    string [] names; 
    mapping(string=>uint256) numericByName; 
    mapping(address=>string) nameByAddress; 
    mapping(string=>address) addressByName; 
    mapping(string=>bool) knownName; 
    mapping(address=>bool) knownAddress; 
    mapping(address=>uint256) versionByAddress; 

    constructor(address _admin) {
        admin = _admin; 
        self = address(this);
        addAddressInternal(ZK_ADMIN, _admin, 0);
        addAddressInternal(name, self, version);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function isKnownName(string memory _name)view external returns (bool _isKnownName){
        return knownName[_name];
    }   

    function isKnownAddress(address _address) view external returns (bool _isKnownAddress){
        return knownAddress[_address];
    }

    function getName(address _address) view external returns (string memory _name){
        return nameByAddress[_address];
    }

    function getUINTValue(string memory _name) view external returns (uint256 _value){        
        return numericByName[_name]; 
    }

    function getAddress(string memory _name) view external returns (address _address){
        return addressByName[_name];
    }

    function getConfig() view external returns (Config [] memory _configuration){
        _configuration = new Config[](names.length);
        for(uint256 x = 0; x < names.length; x++) {
            _configuration[x] = Config({
                                            name : names[x],
                                            addr : addressByName[names[x]],
                                            version : versionByAddress[addressByName[names[x]]]
                                        });
        }
        return _configuration; 
    }

    function addAddress(string memory _name, address _address, uint256 _version) external adminOnly returns (bool _added){
        return addAddressInternal(_name, _address, _version);
    }

    function addZKVAddress(address _address) external adminOnly returns (bool _added) {
        IZKVersion v_ = IZKVersion(_address);
        return addAddressInternal(v_.getName(), _address, v_.getVersion());
    }

    function setUINTValue(string memory _name, uint256 _value) external adminOnly returns (bool _set) {
        if(!knownName[_name])         {
            names.push(_name);
        }
        knownName[_name] = true;
        numericByName[_name] = _value; 
        return true; 
    }
    //============================================== INTENRAL ===============================================================

    function addAddressInternal(string memory _name, address _address, uint256 _version) internal returns (bool _added){
        if(!knownName[_name]){
            names.push(_name);
            knownName[_name] = true; 
        }
        nameByAddress[_address] = _name;  
        addressByName[_name] = _address; 
        knownName[_name] = true; 
        knownAddress[_address] = true; 
        versionByAddress[_address] = _version; 

        return true; 
    }
}