const Splitter = artifacts.require("./Splitter.sol");
const Promise = require("bluebird");
Promise.promisifyAll(web3.eth, { suffix: "Promise" });

contract('Splitter', accounts => {
  console.log(accounts);

  var contract;
  var alice = accounts[0];
  var bob = accounts[1];
  var carol = accounts[2];

  beforeEach('setup split', async () => {contract = await Splitter.new({from: alice})});
  
  it('should be owned by alice', function() {
    return contract.owner({from: alice})
      .then(function(owner) {
        assert.strictEqual(owner, alice);
      });
  });

  it('should split even amounts', function() {
    return contract.sendSplit(bob, carol, {from: alice, value: 100 })
      .then(tx => contract.balances(bob))
      .then(bobBalance => assert.equal('50', bobBalance.toString(10)))
      .then(() => contract.balances(carol))
      .then(carolBalance => assert.equal('50', carolBalance.toString(10)))
  });

  it('should split odd amounts', function() {
    return contract.sendSplit(bob, carol, {from: alice, value: 101 })
      .then(tx => contract.balances(bob))
      .then(bobBalance => assert.equal('51', bobBalance.toString(10)))
      .then(() => contract.balances(carol))
      .then(carolBalance => assert.equal('51', carolBalance.toString(10)))
  });

  describe('withdraws', function(){

  beforeEach('setup withdraw', async () => { return contract.sendSplit(bob,carol,{ from: alice, value: 100 })} );


  it('should be able to withdraw', async function() {
    let beforeBobBalance = await web3.eth.getBalancePromise(bob)
    return contract.withdraw({from: bob})
      .then(txObject => gasCost = web3.eth.getTransactionPromise(txObject.tx).gasPrice.times(txObject.receipt.gasUsed))
      .then(afterBobBalance => assert.equal(beforeBobBalance.plus(50).minus(gasCost), afterBobBalance))
    });
  });

});