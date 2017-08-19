var SafeMathLib = artifacts.require("./SafeMathLib.sol");
var NavCoinSimple = artifacts.require("./NavCoinSimple.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMathLib);
  deployer.link(SafeMathLib, NavCoinSimple);
  deployer.deploy(NavCoinSimple, "NavCoinSimple", "NCN", 100, 18);
};
