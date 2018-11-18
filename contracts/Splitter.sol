pragma solidity ^0.4.22;

contract Splitter {

  address owner;

  mapping (address => uint) public balances;

  event LogContractInit(address sender);
  event LogFundsRecieved(address sender ,address reciever1, address reciever2, uint amountRecieved);
  event LogWithdraw(address sender, uint balance);
  //INIT CONTRACT
  constructor () public {
      owner = msg.sender;
      emit LogContractInit(msg.sender);
    }

  function sendSplit(address reciever1, address reciever2) public payable onlyOwner returns(bool success) {
      require(msg.value > 0);
      require(reciever1 != 0);
      require(reciever2 != 0);
      require(msg.value % 2 == 0);
      uint value = msg.value/2;
      balances[reciever1] += value;
      balances[reciever2] += value;
      emit LogFundsRecieved(msg.sender,reciever1,reciever2,value);
      return true;
    }

  function withdraw()public onlyOwner returns(bool success) {
    require(balances[msg.sender] > 0);
    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    emit LogWithdraw(msg.sender, amount);
    msg.sender.transfer(amount);
    return true;
  }

  modifier onlyOwner {
    require(owner == msg.sender);
    _;
  }

  function checkBalance(address user)public constant returns(uint balance) {
    return balances[user];
  }
}
