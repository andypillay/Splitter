pragma solidity 0.4.24;

contract Splitter {

  address public owner;
  uint value;

  mapping (address => uint) public balances;

  event LogContractInit(address sender);
  event LogFundsRecieved(address indexed sender ,address indexed reciever1, address indexed reciever2, uint amountRecieved);
  event LogWithdraw(address sender, uint balance);

  modifier onlyOwner {
    require(owner == msg.sender);
    _;
  }


  constructor () public {
      owner = msg.sender;
      emit LogContractInit(msg.sender);
    }

  function sendSplit(address reciever1, address reciever2) public payable returns(bool success) {
      require(msg.value > 0);
      require(reciever1 != 0);
      require(reciever2 != 0);
      if(msg.value % 2 == 0)
        value = msg.value/2;
      else
      {
        uint remainder = msg.value - (2 * (msg.value / 2));
        value = (msg.value- remainder)/2;
      }
      balances[reciever1] += value; 
      balances[reciever2] += value;
      emit LogFundsRecieved(msg.sender,reciever1,reciever2,value);
      return true;
    }

  function withdraw() public returns(bool success){
    uint amount = balances[msg.sender];
    require(amount > 0);
    balances[msg.sender] = 0;
    emit LogWithdraw(msg.sender, amount);
    msg.sender.transfer(amount);
    return true;
  }

}
