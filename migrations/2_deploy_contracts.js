var Splitter = artifacts.require("./Splitter.sol");

module.exports = function(deployer,networks,accounts) {
  deployer.deploy(Splitter);
};