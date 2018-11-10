pragma solidity ^0.4.22;


contract Splitter {
  struct Account {
    bool isMember;
    uint balance;  
  } 

  mapping (address=>Account) private accounts;
  address[] private addressIndices;

  event ContactInit(address[] addresses);

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

  function withdraw(uint reqAmount, bool all) internal senderIsUser returns(bool isSuccess){

  }





}
