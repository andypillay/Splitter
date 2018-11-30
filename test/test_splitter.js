const Splitter = artifacts.require("./Splitter.sol");
const Promise = require("bluebird");
Promise.promisifyAll(web3.eth, { suffix: "Promise" });

contract('Splitter', accounts => {
  console.log(accounts);

  var contract;
  var alice = accounts[0];
  var bob = accounts[1];
  var carol = accounts[2];

  beforeEach('setup split', async () => { contract = await Splitter.new({ from: alice }) });

  it('should be owned by alice', function () {
    return contract.owner({ from: alice })
      .then(function (owner) {
        assert.strictEqual(owner, alice);
      });
  });

  it('should split even amounts', function () {
    return contract.sendSplit(bob, carol, { from: alice, value: 100 })
      .then(tx => contract.balances(bob))
      .then(bobBalance => assert.strictEqual('50', bobBalance.toString(10)))
      .then(() => contract.balances(carol))
      .then(carolBalance => assert.strictEqual('50', carolBalance.toString(10)))
  });

  it('should split odd amounts', function () {
    return contract.sendSplit(bob, carol, { from: alice, value: 101 })
      .then(tx => contract.balances(bob))
      .then(bobBalance => assert.strictEqual('50', bobBalance.toString(10)))
      .then(() => contract.balances(carol))
      .then(carolBalance => assert.strictEqual('50', carolBalance.toString(10)))
  });

  describe('withdraws', function () {
    var gasUsed; var tx;
    beforeEach('setup withdraw', async () => {
      tx = await contract.sendSplit(bob, carol, { from: alice, value: 100 })
      gasUsed = tx.receipt.gasUsed;
    });


    it('should be able to withdraw', async function () {
      let beforeBobBalance = await web3.eth.getBalancePromise(bob)
      return contract.withdraw({ from: bob })
        .then(tx => web3.eth.getTransactionPromise(tx.tx))
        .then(tx => tx.gasPrice)
        .then(gasPrice => gasPrice.times(gasUsed))
        .then(gasCost => assert.strictEqual(web3.fromWei(beforeBobBalance, "ether").toString(10), web3.fromWei(web3.eth.getBalance(bob), "ether").toString(10)))
    });
  });



});