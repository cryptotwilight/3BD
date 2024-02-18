// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IZKVersion.sol";
import "../interfaces/IZKRegister.sol";
import "../interfaces/IZKDeedContract.sol";
import "../interfaces/IZKDeed.sol";
import "../interfaces/IZKDAContractFactory.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract ZKDeedContract is IZKDeedContract, IZKVersion, ERC721 { 

    modifier deedAssetContractOnly(uint256 _deedId) { 
        require(msg.sender == deedAddressById[_deedId], " deed only ");
        _; 
    }


    string constant nme = "RESERVED_ZK_DEED_CONTRACT"; 
    uint256 constant version = 2;     
    address immutable self; 

    string constant ZK_DEED_ASSET_CONTRACT_FACTORY = "RESERVED_ZK_DEED_ASSET_CONTRACT_FACTORY";

    mapping(address=>bool) isKnownByDeedAddress;
    mapping(uint256=>address) deedAddressById;
    mapping(address=>uint256[]) deedIdsByOwner;
    mapping(address=>mapping(uint256=>bool)) isKnownToOwnerByOwner; 
    mapping(uint256=>bool) knownDeed; 
    
    IZKRegister register; 

    constructor(address _register, string memory _name, string memory _symbol) ERC721(_name, _symbol){
        register = IZKRegister(_register);        
        self = address(this);
    }

    function getName() pure external returns (string memory _name) {
        return nme; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function isKnown(address _zkDeed) view external returns (bool _isKnown){
        return isKnownByDeedAddress[_zkDeed];
    }

    function getOwner(address _zkDeed) view external returns (address _owner){
        return ownerOf(IZKDeed(_zkDeed).getDeedContractId());
    }

    function getDeedIds(address _owner) view external returns (uint256 [] memory _deedIds){
        return deedIdsByOwner[_owner];
    }

    function getZKDeed(uint256 _deedId) view external returns (address _zkDeed){
        return deedAddressById[_deedId];
    }

    function mintZKDeed(address _owner) external returns (uint256 _deedId){
        _deedId = getIndex(); 
        _mint(_owner, _deedId);
        knownDeed[_deedId] = true;
        address deedAddress_ = IZKDAContractFactory(register.getAddress(ZK_DEED_ASSET_CONTRACT_FACTORY)).getZKAssetContract(self, _deedId);
        deedAddressById[_deedId] = deedAddress_; 
        return _deedId; 
    }

    function burnZkDeed(uint256 _deedId) deedAssetContractOnly(_deedId) external returns (address _zkDeed){        
        _burn(_deedId);
        _zkDeed = deedAddressById[_deedId];
        delete deedAddressById[_deedId];
        return _zkDeed; 
    }

    // ========================================= INTERNAL =============================================


    function _update(address _to, uint256 _deedId, address _auth ) override internal returns (address _address) {
        if(knownDeed[_deedId]){
            address previousOwner_ = ownerOf(_deedId);
            delete isKnownToOwnerByOwner[previousOwner_][_deedId];
            deedIdsByOwner[previousOwner_] = deleteId(_deedId, deedIdsByOwner[previousOwner_]);
        }
        isKnownToOwnerByOwner[_to][_deedId] = true;    
        deedIdsByOwner[_to].push(_deedId);
        return super._update(_to, _deedId, _auth );
    }

    uint256 index; 

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }

    function deleteId(uint256 _id, uint256 [] memory _ids) pure internal returns (uint256 [] memory _result){
        _result = new uint256[](_ids.length - 1);
        uint256 y_ = 0; 
        for(uint256 x = 0; x < _ids.length; x++) {
            if(_id != _ids[x]){
                _result[y_] = _ids[x];
                y_++;
            }
        }
        return _result; 
    }
}