pragma solidity ^0.4.22;


contract Splitter {
  struct Account {
    bool isMember;
    uint balance;
    bool isSender;
  } 

  mapping (address=>Account) private accounts;
  address[] private addrs;
  address[] nonSenderaddresses;

  uint private currentBalance;

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
        accounts[addresses[i]] = Account(true,0,false);
        addrs.push(addresses[i]);
    }
    emit ContactInit(addresses);
    }
  }

  function getOtherAccounts() internal paymentSenderIsAuth returns (address[] recievers) {
    for (uint i = 0; i < addrs.length; i++) {
      if (addrs[i] == msg.sender) {
        accounts[msg.sender].isSender = true;
      } else {
        accounts[addrs[i]].isSender = false;
        nonSenderaddresses.push(addrs[i]);
      }
    }
    return nonSenderaddresses;
  }

  function splitBalance() public paymentSenderIsAuth returns (bool success) {
    currentBalance = accounts[msg.sender].balance;
    accounts[msg.sender].balance = 0;
    address[] memory recievers;
    recievers = getOtherAccounts();
    uint numberOfRecivers = recievers.length;
    uint cut = currentBalance/numberOfRecivers;

    for (uint index = 0; index < numberOfRecivers; index++) {
        accounts[recievers[index]].balance += cut;
    }

    emit BalanceSplit(msg.sender);
    return true;
  }
}
