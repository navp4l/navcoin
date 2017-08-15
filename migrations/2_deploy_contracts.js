var ConvertLib = artifacts.require("./ConvertLib.sol");
var NavCoin = artifacts.require("./NavCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, NavCoin);
  deployer.deploy(NavCoin, "NavCoin", "NCN", 100, 2);
};
