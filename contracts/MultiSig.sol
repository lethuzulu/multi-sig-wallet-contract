// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract MultiSig {
    struct Transaction { 
        address destination;
        uint value;
        bool executed;
        bytes data;
    }


    address[] public owners;
    uint public signatures;

    //transactionId => Transaction
    mapping(uint =>Transaction) public transactions;
    uint public transactionCount;

    //transactionId => address(owner) => boolean(i.e whether the owner has confirmed/signed-off on the transaction)
    mapping(uint => mapping(address =>bool)) public confirmations;
    //transactionId => confirmationCount
    mapping(uint => uint) public confirmationCount;

    constructor(address[] memory _owners, uint _signatures){
        require(_owners.length != 0, "No Owners Configured" );
        require(_signatures !=0, "Number of Required Signatures is Zero" );
        require(_signatures < _owners.length, "Number of Signatures is Greater Than The Number of Owners");
        owners = _owners;
        signatures = _signatures;
    }



    function addTransaction(address destination, uint value, bytes calldata data) internal returns(uint){ 
        uint transactionId = transactionCount++;
        transactions[transactionId] = Transaction(destination, value, false, data);
        return transactionId;
    }

    function confirmTransaction(uint transactionId) public {
        require(isOwner(), "Not Owner");
        confirmations[transactionId][msg.sender] = true;
        uint count = confirmationCount[transactionId];
        confirmationCount[transactionId] = ++count;
        if(isConfirmed(transactionId)){
            executeTransaction(transactionId);
        }
    }

    function getConfirmationsCount(uint transactionId) public view returns(uint) {
        return confirmationCount[transactionId];
    }

    function submitTransaction(address destination, uint value, bytes calldata data) external {
        // add transaction to the list of transactions 
        // immediately confirm the transaction 
        uint transactionId = addTransaction(destination, value, data);
        confirmTransaction(transactionId);
    }

    receive() payable external {}

    function isOwner() internal view returns(bool) {
        bool status = false;
        for(uint i = 0; i < owners.length; i++){
            if(msg.sender == owners[i]){
                status = true;
                break;
            }
        }
        return status;
    }

    function isConfirmed(uint transactionId) public view returns(bool) {
        bool status = false;
        //for the transaction to be confirmed than its confirmationsCount should not be less than the number of required signatures.
        if(signatures <= getConfirmationsCount(transactionId)){
            status = true;
        }
        return status;
    }

    function executeTransaction(uint transactionId) public {
        require(isConfirmed(transactionId), "Not Confirmed");
        Transaction storage transaction = transactions[transactionId];

        (bool success, ) = transaction.destination.call{value:transaction.value}(transaction.data);

        require(success, "Failed to Transfer Ether");
        transaction.executed = true;
    }
}
