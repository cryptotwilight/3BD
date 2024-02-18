// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IZKVersion.sol";
import "../interfaces/IZKRegister.sol";
import "../interfaces/IZKDeedAssetContract.sol";
import "../interfaces/IZKOracle.sol";
import {ZKComposition} from "../interfaces/IZKDStructs.sol";
import "../interfaces/IZKProofGenerator.sol";

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC1155.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";


contract ZKDeedAssetContract is IZKDeedAssetContract, IZKVersion { 

    modifier ownerOnly {
        require(msg.sender == IERC721(deedContract).ownerOf(deedId), "deed owner only");
        _;
    }

    modifier deedPoolOnly { 
        require(msg.sender == register.getAddress(ZK_DEED_POOL), " deed pool only ");
        _;
    }

    string constant name = "ZK_DEED_ASSET_CONTRACT";
    uint256 constant version = 4; 

    string constant VALUATION_EXPIRY_MAX_PERIOD = "VALUATION_EXPIRY_MAX_PERIOD";
    string constant ZK_ORACLE = "RESERVED_ZK_ORACLE";
    string constant ZK_PROOF_GENERATOR = "RESERVED_ZK_PROOF_GENERATOR";
    string constant ZK_DEED_POOL = "RESERVED_ZK_DEED_POOL";

    uint256 constant MAX_ASSET_COUNT = 10; 
    bool constant INCREMENT = true; 
    bool constant DECREMENT = false; 

    IZKRegister register; 
    address immutable self; 
    address immutable deedContract; 
    uint256 immutable deedId;
    bool isDissolved; 
    bool isDeedLocked; 
    string descriptor;

    uint256 value; 
    uint256 valuationDate; 
    address denomination; 
    ZKComposition composition; 
    mapping(AssetType=>uint256) valueByAssetType; 

    mapping(AssetType=>bool) hasAssetTypeByAssetType; 
    mapping(uint256=>bool) hasAssetIdByAssetId; 
    uint256 assetCount; 
    uint256 index; 
    mapping(uint256=>Asset) assetById; 
    uint256 [] assetIds; 


    constructor(address _zkRegister, address _zkDeedContract, uint256 _zkDeedId){ 
        register = IZKRegister(_zkRegister);
        deedContract = _zkDeedContract; 
        deedId = _zkDeedId; 
        self = address(this);
        composition = ZKComposition({
                                        erc20 : 0,
                                        erc721 : 0,
                                        erc1155 : 0
                                    });
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getDescriptor() view external returns (string memory _descriptor) {
        return descriptor; 
    }

    function getComposition() view external returns (ZKComposition memory _composition){
        return composition; 
    }

    function hasType(AssetType _type) view external returns (bool _hasType){
        return hasAssetTypeByAssetType[_type];
    }

    function isLocked() view external returns (bool _isLocked) {
        return isDeedLocked; 
    }

    function isAboveValue(uint256 _amount, address _erc20) view external returns (bool _isAboveValue, ZKProof memory _proof){
        require(isDeedLocked, "deed not locked, composition unstable");
        uint256 conversion_ = IZKOracle(register.getAddress(ZK_ORACLE)).getPrice(IERC20Metadata(_erc20).symbol(), IERC20Metadata(denomination).symbol());
        (bool ok_, uint256 converted_) = Math.tryDiv(value, conversion_);
        if(ok_){
            _isAboveValue = converted_ > _amount; 
            _proof = IZKProofGenerator(register.getAddress(ZK_PROOF_GENERATOR)).calculateProof(converted_, denomination, _amount,  _erc20);
        }
        return (_isAboveValue, _proof);
    }

    function getDeedContract() view external returns (address _deedContract){
        return deedContract; 
    }

    function getDeedContractId() view external returns (uint256 _deedContractId){
        return deedId; 
    }

    function getAssets() view ownerOnly external returns (Asset [] memory _assets){
        _assets = new Asset[](assetCount);
        uint256 y = 0; 
        for(uint256 x = 0; x < assetIds.length; x++){
            if(hasAssetIdByAssetId[assetIds[x]]){
                _assets[y] = assetById[assetIds[x]];
                y++;
            }
        }
        return _assets; 
    }

    function hasAsset(uint256 _assetId) view ownerOnly external returns (bool _hasAsset){
        return hasAssetIdByAssetId[_assetId];
    }

    function addAsset(Asset memory _asset) payable ownerOnly external returns (uint256 _assetId){
        require(!isDissolved, " deed dissolved ");
        require(!isDeedLocked, " deed locked ");
        require(assetCount > MAX_ASSET_COUNT, "asset count exceeded");
        _assetId = addAssetInternal(_asset);
        assetCount++;
        return _assetId; 
    }

    function removeAsset(uint256 _assetId) external ownerOnly returns (Asset memory _asset){
        require(!isDissolved, " deed dissolved ");
        require(!isDeedLocked, " deed locked ");
        require(hasAssetIdByAssetId[_assetId], "unknown asset");
        _asset = assetById[_assetId];        
        removeAssetInternal(_asset);
        assetCount--;
    }

    function lockDeed() external ownerOnly  returns (bool _isLocked){
        isDeedLocked = true;         
        return isDeedLocked; 
    }

    function unlockDeed() external ownerOnly returns (bool _isLocked) {
        isDeedLocked = false; 
        return isDeedLocked; 
    }

    function updateValue() external ownerOnly returns (uint256 _value, address _erc20, uint256 _valuationDate){
        for(uint256 x = 0; x < assetIds.length; x++) {
           if(hasAssetIdByAssetId[assetIds[x]]){
                Asset memory asset_ = assetById[assetIds[x]];
                _value += getAssetValue(asset_);
           }
        }
        value = _value; 
        valuationDate = _valuationDate = block.timestamp; 
        return (_value, denomination, _valuationDate);
    }

    function getValue() view external ownerOnly returns (uint256 _value, address _erc20, uint256 _valuationDate){
        require(valuationDate <= register.getUINTValue(VALUATION_EXPIRY_MAX_PERIOD), "valuation too old");
        return (value, denomination, valuationDate);
    }

    function dissolveDeed(address to_) external ownerOnly returns (uint256 _assetCount) {
        for(uint256 x = 0; x < assetIds.length; x++) {
            if(hasAssetIdByAssetId[assetIds[x]] ) {
                removeAssetInternal(assetById[assetIds[x]], to_);
                _assetCount++;
            }
        }
    }

    function getDenomination() view external returns (address _erc20){
        return denomination; 
    }

    function setDenomination(address _erc20) external ownerOnly returns (bool _demoninationSet){
        denomination = _erc20; 
        return true; 
    }

    function updateDescriptor(string memory _descriptor) external ownerOnly returns (bool _updated) {
        descriptor = _descriptor; 
        return true; 
    }

    //========================================= INTERNAL ==============================================================

    function getAssetValue(Asset memory _asset) view internal returns (uint256 _value) {
        IZKOracle oracle_ = IZKOracle(register.getAddress(ZK_ORACLE));
        if(_asset.aType == AssetType.ERC20) {
            uint256 price_ = oracle_.getPrice(IERC20Metadata(_asset.assetContract).symbol(), IERC20Metadata(denomination).symbol());
            (bool ok_, uint256 converted_) = Math.tryDiv(_asset.amount, price_);
            if(ok_){
                _value = converted_; 
            }
            else { 
                _value = 0; 
            }
            return _value; 
        }
        if(_asset.aType ==AssetType.ERC721) {
            _value = oracle_.getFloorPrice(_asset.assetContract, IERC20Metadata(denomination).symbol());
            return _value; 
        }
        if(_asset.aType == AssetType.ERC1155) {
             
        }
    }

    function removeAssetInternal(Asset memory _asset, address _to ) internal  {
        uint256 value_ = getAssetValue(_asset);
        value -= value_; 
        updateComposition(value_, _asset.aType, DECREMENT);
        
        delete assetById[_asset.id];
        delete hasAssetIdByAssetId[_asset.id];
        transferAsset(self, _to, _asset);
    }

    function removeAssetInternal(Asset memory _asset) internal {        
        removeAssetInternal(_asset, msg.sender);
    }

    function transferAsset(address _from, address _to, Asset memory _asset) internal { 
        if(_asset.aType == AssetType.ERC721){
            IERC721 erc721_ = IERC721(_asset.assetContract);
            erc721_.transferFrom(_from, _to, _asset.assetContractId);
            return; 
        }

        if(_asset.aType == AssetType.ERC20) {
            IERC20 erc20_ = IERC20(_asset.assetContract);
            if(_from == self) {
                erc20_.transfer(_to, _asset.amount);
            }
            else { 
                erc20_.transferFrom(_from, _to, _asset.amount);
            }            
            return; 
        }
        if(_asset.aType == AssetType.ERC1155) {
            return; 
        }
    }

    function updateComposition(uint256 _value, AssetType _assetType, bool _increment)  internal { 
        if(_increment) {
            valueByAssetType[_assetType] += _value;
            value += _value; 
        }
        else { 
            valueByAssetType[_assetType] -= _value;
            value -= _value; 
        }
        uint256 total_ = valueByAssetType[AssetType.ERC1155] + valueByAssetType[AssetType.ERC20] + valueByAssetType[AssetType.ERC721];

        composition.erc20 = getPercentage(valueByAssetType[AssetType.ERC20], total_);
        composition.erc721 = getPercentage(valueByAssetType[AssetType.ERC721], total_);
        composition.erc1155 = getPercentage(valueByAssetType[AssetType.ERC1155], total_);
    }

    function getPercentage(uint256 _value, uint256 _total) pure internal returns (uint256 _percentage) {
        (bool ok_, uint256 factor_ ) = Math.tryDiv(_value , _total);
        if(ok_) {
            (bool ok2_, uint256 percentage_ ) = Math.tryMul(factor_, 100);
            if(ok2_) {
                _percentage = percentage_;
            }
        }
        return _percentage; 
    }

    function addAssetInternal(Asset memory _asset) internal returns (uint256 _assetId) {
        transferAsset(msg.sender, self, _asset);
        uint256 value_ = getAssetValue(_asset);
        value += value_; 
        updateComposition(value_, _asset.aType, INCREMENT);
        
        _assetId = getIndex(); 
        assetIds.push(_assetId);
        hasAssetIdByAssetId[_assetId] = true; 
        hasAssetTypeByAssetType[_asset.aType] = true; 
        assetById[_assetId] = Asset({
                                id : _assetId, 
                                aType : _asset.aType, 
                                assetContract : _asset.assetContract, 
                                amount : _asset.amount, 
                                assetContractId : _asset.assetContractId
                            });
        return _assetId; 
    }

    function getIndex() internal returns (uint256 _index){
        _index = index++; 
        return _index; 
    }
}
