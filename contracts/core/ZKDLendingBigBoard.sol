// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IZKVersion.sol";
import "../interfaces/IZKRegister.sol";
import "../interfaces/IZKDLendingBigBoard.sol";

import "../interfaces/IZKDeed.sol";
import "../interfaces/IZKDeedContract.sol";

import {ZKProof} from "../interfaces/IZKDStructs.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";


contract ZKDLendingBigBoard is IZKDLendingBigBoard, IZKVersion { 

    modifier adminOnly { 
        require(msg.sender == register.getAddress(ZK_ADMIN), " admin only ");
        _;
    }

    string constant name = "RESERVED_ZK_DEED_BIG_BOARD";
    uint256 constant version = 1;

    string constant ZK_ADMIN = "RESERVED_ZK_ADMIN";
    address constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; 

    uint256 index; 

    IZKRegister register;
    address immutable self; 

    // requests
    uint256 [] loanRequestIds;
    mapping(uint256=>ZKDLoanRequest) loanRequestById; 
    mapping(uint256=>uint256[]) offerIdsByLoanRequestId; 
    mapping(uint256=>bool) loanRequestActiveByLoanRequestId; 
    
    // offers
    mapping(address=>uint256[]) loanOfferIdsByLender; 
    mapping(uint256=>ZKDLoanOffer) loanOfferById; 
    
    // loans
    uint256 [] loanIds; 
    mapping(address=>uint256[]) activeLoanIdsByLender; 
    mapping(address=>uint256[]) loanIdsByLender; 
    mapping(uint256=>ZKDLoan) loanById; 
    mapping(uint256=>Tx) txById; 


    constructor(address _register) {
        register = IZKRegister(_register);
        self = address(this);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getLoanIds() view external adminOnly returns (uint256 [] memory _loanIds) {
        return _loanIds; 
    }

    function getDeedLoanRequestIds() view external returns (uint256 [] memory _deedLoanRequestIds) {
        return loanRequestIds; 
    }
    
    function isActiveLoanRequest(uint256 _deedLoanRequestId) view external returns (bool _isActive){
        return loanRequestActiveByLoanRequestId[_deedLoanRequestId];
    }

    function getDeedLoanRequest(uint256 _deedLoanRequestId) view external returns (ZKDLoanRequest  memory _zkdLoanRequest){
        return loanRequestById[_deedLoanRequestId]; 
    }

    function getLoanOffersIds(uint256 _loanRequestId) view external returns (uint256 [] memory _offerIds){
        return offerIdsByLoanRequestId[_loanRequestId];
    }

    function getActiveLoanIds() view external returns (uint256 [] memory _loanIds){
        return activeLoanIdsByLender[msg.sender];
    }

    function getLoan(uint256 _loanId) view external returns (ZKDLoan memory _loan){
        return loanById[_loanId];
    }

    function getZKDeedLoanOffer(uint256 _offerId) view external returns (ZKDLoanOffer memory _offer) {
        return loanOfferById[_offerId];
    }

    function postDeedLoanRequest(address _zkDeed, uint256 _requestedLoanAmount) external returns (uint256 _loanRequestId){
        require(isDeedHolder(_zkDeed), "deed holder only");
        IZKDeed deed_ = IZKDeed(_zkDeed);

        (bool satisfied_, ZKProof memory proof_) = deed_.isAboveValue(_requestedLoanAmount, IZKDeed(_zkDeed).getDenomination());
        require(satisfied_ && isValid(satisfied_, proof_), "valuation failure");
        _loanRequestId = getIndex(); 
        loanRequestById[_loanRequestId] = (ZKDLoanRequest({
                                                                id : _loanRequestId,
                                                                zkDeed : _zkDeed, 
                                                                amount : _requestedLoanAmount,
                                                                createDate : block.timestamp,
                                                                borrower : msg.sender
                                                            }));
        loanRequestActiveByLoanRequestId[_loanRequestId] = true;                                                            
        return _loanRequestId; 
    }

    function cancelDeedLoanRequest(uint256 _loanRequestId) external returns (uint256 _txId) {
        ZKDLoanRequest memory request_ = loanRequestById[_loanRequestId];
        require(msg.sender == request_.borrower, "borrower only");
        _txId = getIndex(); 
        loanRequestActiveByLoanRequestId[_loanRequestId] = false;
        delete loanRequestById[_loanRequestId];
        delete offerIdsByLoanRequestId[_loanRequestId];
        return _txId; 
    }

    function retrieveLoanOffer(uint256 _offerId) external returns (uint256 _refunded) {
        ZKDLoanOffer memory offer_ = loanOfferById[_offerId];
        require(msg.sender == offer_.lender, "lender only");
        require(!loanRequestActiveByLoanRequestId[offer_.requestId], "loan still active - cancel instead");
        return teardownLoanOffer(offer_);
    }

    function offerLoan(ZKDLoanOffer memory _zkLoanOffer) external payable returns (uint256 _offerId){
        _offerId = getIndex(); 
        if(_zkLoanOffer.erc20 == NATIVE) {
            require(msg.value == _zkLoanOffer.amount, "insufficient amount transmitted for NATIVE(ETH etc) loan offer");
        }
        offerIdsByLoanRequestId[_zkLoanOffer.requestId].push(_offerId);
        loanOfferById[_offerId] = _zkLoanOffer; 
        loanOfferIdsByLender[msg.sender].push(_offerId);
        return _offerId; 
    }

    function declineOffer(uint256 _offerId) external returns (bool _declined) {
        ZKDLoanOffer memory offer_ = loanOfferById[_offerId];
        address borrower_ = loanRequestById[offer_.requestId].borrower; 
        require(msg.sender == borrower_, "borrower only");
        cancelOfferInternal(offer_);
        return true; 
    }


    function cancelOffer(uint256 _offerId) external returns (uint256 _refunded) {
        ZKDLoanOffer memory offer_ = loanOfferById[_offerId];
        require(msg.sender == offer_.lender, "lender only");
        return cancelOfferInternal(offer_); 
    }

    function acceptOffer(uint256 _offerId) external returns (uint256 _loanId){
        ZKDLoanOffer memory offer_ = loanOfferById[_offerId];
        require(isDeedHolder(offer_.zkDeed), "deed holder only");

        IZKDeed deed_ = IZKDeed(offer_.zkDeed);
        IZKDeedContract deedContract_ = IZKDeedContract(deed_.getDeedContract());
        address borrower_ = deedContract_.getOwner(address(deed_));
 
        // transfer ownership of the deed
        IERC721(address(deedContract_)).transferFrom(borrower_, self, deed_.getDeedContractId());
        // lock the deed from modification
        deed_.lockDeed();

        // ensure the deed value is above the offer amount 
        (bool satisfied_, ZKProof memory proof_) = deed_.isAboveValue(offer_.amount, offer_.erc20);
        // validate the proof submitted 
        require(satisfied_ && isValid(satisfied_, proof_), "valuation failure");

        // remove the loan request from the market
        loanRequestActiveByLoanRequestId[offer_.requestId] = false; 
        delete offerIdsByLoanRequestId[offer_.requestId];
        loanRequestIds = remove(offer_.requestId, loanRequestIds);
        delete loanRequestById[offer_.requestId];

        // issue loan
        _loanId = getIndex(); 
        
        // issue native 
        if(offer_.erc20 == NATIVE) {
            payable(borrower_).transfer(offer_.amount);
        }
        else { 
            // issue erc20 
            IERC20 erc20_ = IERC20(offer_.erc20);
            erc20_.transferFrom(offer_.lender, self, offer_.amount);
            erc20_.transferFrom(self,borrower_ , offer_.amount);
        }
        loanById[_loanId] =  ZKDLoan({ 
                                        id : _loanId,
                                        zkDeed : offer_.zkDeed,  
                                        erc20 : offer_.erc20,
                                        amount : offer_.amount, 
                                        periodInterest : offer_.periodInterest, 
                                        paybackAmount : offer_.paybackAmount,
                                        endDate : block.timestamp + offer_.paybackPeriod, 
                                        startDate : block.timestamp, 
                                        lender : offer_.lender, 
                                        borrower : borrower_,
                                        txIds : new uint256[](0)
                                    });
        activeLoanIdsByLender[offer_.lender].push(_loanId);
        loanIds.push(_loanId);
        loanIdsByLender[offer_.lender].push(_loanId);
        return _loanId; 
    }

    

    function payBackLoan(uint256 _loanId, uint256 _amount) payable external returns (uint256 _txId){
        ZKDLoan memory loan_ = loanById[_loanId];
        require(loan_.paybackAmount > 0, " loan completed ");
        IERC20(loan_.erc20).transferFrom(msg.sender, self, _amount);
        int256 trial_ = int256(loanById[_loanId].paybackAmount) - int256(_amount);
        
        if(trial_ < 0) {
            
            uint256 refund_ = uint256(trial_*-1);
            IERC20(loan_.erc20).transferFrom(self, loan_.lender, loan_.paybackAmount);            

            loanById[_loanId].paybackAmount = 0; 
            IERC20(loan_.erc20).transferFrom(self, msg.sender, refund_);       
            activeLoanIdsByLender[loan_.lender] = remove(_loanId, activeLoanIdsByLender[loan_.lender]);
        }
        else { 
            loanById[_loanId].paybackAmount -= _amount; 
            IERC20(loan_.erc20).transferFrom(self, loan_.lender, _amount);            
        }

        _txId = getIndex(); 
        loanById[_loanId].txIds.push(_txId);
        txById[_txId] = Tx({
                            id : _txId, 
                            txType : "REPAYMENT",
                            createDate : block.timestamp, 
                            amount : _amount, 
                            erc20 : loanById[_loanId].erc20,
                            executor : msg.sender
                         });
        return _txId; 
    }

    function getTx(uint256 _txId) view external returns (Tx memory _tx){
        return txById[_txId]; 
    }
    //=================================== INTERNAL ===========================================

    function cancelOfferInternal(ZKDLoanOffer memory _offer) internal returns (uint256 _refunded) {
        offerIdsByLoanRequestId[_offer.requestId] = remove(_offer.id, offerIdsByLoanRequestId[_offer.requestId]);
        return teardownLoanOffer(_offer);
    }

    function teardownLoanOffer(ZKDLoanOffer memory _offer) internal returns (uint256 _refunded) {
        if(_offer.erc20 == NATIVE) {
            payable(_offer.lender).transfer(_offer.amount);
            _refunded = _offer.amount; 
        }
        else { 
            _refunded = 0; 
        }
        delete loanOfferById[_offer.id];
        return _refunded;  
    }


    function isDeedHolder(address _zkDeed) view internal returns (bool _isDeedHolder) {
        IZKDeed deed_ = IZKDeed(_zkDeed);
        IZKDeedContract deedContract_ = IZKDeedContract(deed_.getDeedContract());
        address owner_ = deedContract_.getOwner(address(deed_));
        return msg.sender == owner_;
    }

    function isValid(bool _answer, ZKProof memory _proof) pure internal returns (bool _isValid) {
        // verify proof
        return true;    
    }

    function remove(uint256 _value, uint256 [] memory _array) pure internal returns (uint256 [] memory _result) {
        _result = new uint256[](_array.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < _array.length; x++) {
            if(_value != _array[x]){
                _result[y] = _array[x];
                y++;
            }
        }
        return _result; 
    }
    

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }
}