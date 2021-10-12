const ForbitswapRouterArtifacts = artifacts.require('ForbitswapRouter');

module.exports = function (deployer) {
	deployer.deploy(
		ForbitswapRouterArtifacts,
		'0x9e352b2869850A3fE1689A7b8c1c1b6FA73C0b58',
		'0xc778417E063141139Fce010982780140Aa0cD5Ab'
	);
};
