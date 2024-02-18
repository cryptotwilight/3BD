// SPDX-License-Identifier: GPL-3.0

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

interface IZKDeedPool { 

    function depositDeed(address deedContract, uint256 deedId) external returns (uint256 _txId);

    function withdrawDeed(uint256 _depositTxId) external returns (uint256 _txId);

    function getTxIds() view external returns (uint256 [] memory _txIds);

    function getDepositTxIds() view external returns (uint256 [] memory _txIds);

    function getCurrency() view external returns (address _currency);

    function getBalance(uint256 _depositTxId) view external returns (uint256 _balance);

    function getTxInfo(uint256 _txId) view external returns (TX memory _tx);

    function borrow(uint256 _amount) external returns (uint256 _amt);

    function repay(uint256 _amount) payable external returns (uint256 _balance);
}