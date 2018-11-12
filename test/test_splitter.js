const Splitter = artifacts.require("./Splitter.sol");
const Promise = require("bluebird");

Promise.promisifyAll(web3.eth, { suffix: "Promise" });

contract('Splitter', accounts => {
    console.log(accounts);

    it("should ", isSuccessful => {

      return MetaCoin.deployed().then(function(instance) {
        return instance.getBalance.call(accounts[0]);
      }).then(function(balance) {
        assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
      });
    });

});