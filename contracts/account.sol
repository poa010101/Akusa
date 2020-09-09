pragma solidity ^0.5.0;

contract account {

    //mapping (address => string) public balances;
    mapping (uint => uint) public accounts;
    //address [] public myBalance;
    uint [] public myAccount;
    uint public price;
    event LogSet(address userAddress, string amount);
    event LogGet(address userAddress, string amount);
    event LogTransfer(uint accID, address to, uint amount);
    event LogDeposit(uint accID, address tdAddress, uint amount);
    event LogWithdrawal(uint accID, address userAddress, uint amount);

   //new account value =0 
   
   
    function create(uint accID) public payable returns(bool success) {
        accounts[accID] =0;
        myAccount.push(accID)-1;
        //tdAddress.transfer(msg.value);
        //LogDeposit(accID,tdAddress, accounts[accID]);
        return true;
    }
    // "0x9702ca361b6EDbfFdFe6E9441a9F82EE4515C00B"
    function deposit(uint accID, address tdAddress) public payable returns(bool success) {
        accounts[accID] +=msg.value;
        address payable to = address(uint160(tdAddress));
        to.transfer(msg.value);
        emit LogDeposit(accID, to, accounts[accID]);
    }
    
    /*function withdraw(uint accID) public payable returns(bool success){
        if(accounts[accID] < price) revert();
        //accounts[accID] -= price;  
        accounts[accID] -= price;
        msg.sender.transfer(price);
        emit LogWithdrawal(accID, msg.sender, accounts[accID]);
        return true;
    }*/

     function transfer(uint accID, address toAddress) public payable returns(bool success) {

        if(accounts[accID] < msg.value) revert();
        accounts[accID] -= msg.value;
        address payable to = address(uint160(toAddress));
        to.transfer(msg.value);
        emit LogTransfer(accID, to, accounts[accID]);
        return true;
    }

}