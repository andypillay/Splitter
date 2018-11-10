pragma solidity ^0.4.22;


contract Splitter {
  struct Account {
    bool isMember;
    uint balance;  
  } 

  mapping (address=>Account) private accounts;
  address[] private addressIndices;

  uint public currentBalance;

  event ContactInit(address[] addresses);
  event BalanceSplit(address sender);

  modifier paymentSenderIsAuth() {
    require(accounts[msg.sender].isMember, "Account is not authourised member.");
    _;
  }

  //INIT CONTRACT
  constructor (address[] addresses) public {
    require(addresses.length == 3);
    {
      for (uint i = 0; i < addresses.length; i++) {
        accounts[addresses[i]] = Account(true,0);
        addressIndices.push(addresses[i]);
    }
    emit ContactInit(addresses);
    }
  }

  function getOtherAccounts() internal view paymentSenderIsAuth returns (address[] otherUsers) {
    if (addressIndices[0] == msg.sender) {
      otherUsers.push(addressIndices[1]);
      otherUsers.push(addressIndices[2]);
      return(otherUsers);
    } 
  }

  function splitBalance() public paymentSenderIsAuth returns (bool success) {
    (bob,carol) = getOtherAccounts();
    currentBalance = accounts[msg.sender].balance;
    accounts[msg.sender].balance = 0;

    accounts[bob].balance += currentBalance/2;
    accounts[carol].balance += currentBalance/2;

    emit BalanceSplit(msg.sender);
    return true;
  }





}
