var SafeMathLib = artifacts.require("./SafeMathLib.sol");
var ERC20TokenInterface = artifacts.require("./ERC20TokenInterface.sol");
var Owned = artifacts.require("./Owned.sol");
var NavCoinSimple = artifacts.require("./NavCoinSimple.sol");

module.exports = function(deployer) {
  deployer.deploy(ERC20TokenInterface);
  deployer.deploy(Owned);
  deployer.deploy(SafeMathLib);
  deployer.link(SafeMathLib, NavCoinSimple);
  deployer.deploy(NavCoinSimple, "NavCoinSimple", "NCN", 100, 18);
};

