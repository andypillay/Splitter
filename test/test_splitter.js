const Splitter = artifacts.require("./Splitter.sol");
Promise = require("bluebird");
Promise.promisifyAll(web3.eth, { suffix: "Promise" });

contract('Splitter', accounts => {
  console.log(accounts);

  var contract;
  var alice = accounts[0];
  var bob = accounts[1];
  var carol = accounts[2];

  beforeEach('setup', async () => {contract = await Splitter.new({from: alice})});
  
  it('should be owned by alice', function() {
    return contract({from: alice})
      .then(function(owner) {
        assert.strictEqual(owner, alice);
      });
  });

  
  it('should split even amounts', async (isSuccessful) => {
    return await contract.sendSplit(bob, carol, {from: alice, value: 100 })
      .then((tx) => {
         contract.checkBalance(alice).then((balance) => {
          assert.equal('0', balance);
        });

         contract.checkBalance(bob).then((balance) => {
          assert.equal('50', balance);
        });

         contract.checkBalance(carol).then((balance) => {
          assert.equal('50', balance);
        });
      });
    }
  );

  it('should be able to withdraw', async (isSuccessful) => {
    var oldBalance = web3.eth.getBalance(bob);
    var price = 0;
    return await contract.sendSplit(bob, carol, {from: alice, value: 100, gasPrice: 1})
      .then(tx => {
        return contract.withdraw({from: bob, gasPrice: 1})
      })
      .then(tx => {
        price = tx.receipt.gasUsed;
        assert.equal(oldBalance.minus(price).plus(50).toString(), web3.eth.getBalance(bob));
      });
  });
});