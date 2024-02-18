// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

struct Tx { 
    uint256 id; 
    string txType; 
    uint256 createDate; 
    uint256 amount; 
    address erc20; 
    address executor; 
}


struct ZKDLoan { 
    uint256 id; 
    address zkDeed; 
    address erc20; 
    uint256 amount; 
    uint256 periodInterest; 
    uint256 paybackAmount; 
    uint256 endDate; 
    uint256 startDate;
    address lender; 
    address borrower;      
    uint256 [] txIds; 
}

struct ZKDLoanOffer{ 
    uint256 id; 
    uint256 requestId; 
    address zkDeed; 
    address erc20;
    uint256 amount; 
    uint256 periodInterest;
    uint256 paybackAmount;  
    uint256 paybackPeriod; 
    uint256 expires; 
    uint256 createDate; 
    address lender; 
}

struct ZKDLoanRequest {
    uint256 id;  
    address zkDeed; 
    uint256 amount; 
    uint256 createDate; 
    address borrower; 
}

interface IZKDLendingBigBoard { 

    function getDeedLoanRequestIds() view external returns (uint256 [] memory _deedLoanRequestIds);

    function getDeedLoanRequest(uint256 _deedLoanRequestId) view external returns (ZKDLoanRequest  memory _zkdLoanRequest);

    function getLoanOffersIds(uint256 _loanRequestId) view external returns (uint256 [] memory _offerIds);

    function getZKDeedLoanOffer(uint256 _offerId) view external returns (ZKDLoanOffer memory _offer);

    function getActiveLoanIds() view external returns (uint256 [] memory _loanIds);

    function getLoan(uint256 _loanId) view external returns (ZKDLoan memory _loan);

    function postDeedLoanRequest(address _zkDeed, uint256 _requestedLoanAmount) external returns (uint256 _postingId);

    function offerLoan(ZKDLoanOffer memory _zkLoanOffer) external payable returns (uint256 _offerId);

    function acceptOffer(uint256 _offerId) external returns (uint256 _acceptanceId);

     function payBackLoan(uint256 _loanId, uint256 _amount) payable external returns (uint256 _txId);

    function getTx(uint256 _txId) view external returns (Tx memory _tx);
} 