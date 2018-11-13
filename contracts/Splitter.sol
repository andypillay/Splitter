pragma solidity ^0.4.22;

contract Splitter {

  address alice;

  mapping (address => uint) public balances;

  event LogContractInit(address sender);
  event LogBalanceSplit(address sender, uint balance);
  event LogFundsRecieved(address reciever1, address reciever2, uint amountRecieved);
  event LogWithdraw(address sender, uint balance);
  //INIT CONTRACT
  constructor () public {
      alice = msg.sender;
      emit LogContractInit(msg.sender);
    }

  function sendSplit(address bob, address carol) public payable returns(bool success) {
      require(msg.value > 0);
      require(bob != 0);
      require(carol != 0);
      if (msg.sender == alice) {
        uint value = msg.value/2;
        emit LogBalanceSplit(msg.sender, msg.value);
        balances[bob] += value;
        balances[carol] += value;
        emit LogFundsRecieved(bob,carol,value);
        return true;
      } 
    }

  function withdraw()public returns(bool success) {
    require(balances[msg.sender] > 0);
    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    msg.sender.transfer(amount);
    emit LogWithdraw(msg.sender, amount);
    return true;
  }

  function checkBalance(address user)public constant returns(uint balance) {
    return balances[user];
  }
}
