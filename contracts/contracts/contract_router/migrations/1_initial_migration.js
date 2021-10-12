const ForbitswapRouterArtifacts = artifacts.require('ForbitswapRouter');

module.exports = function (deployer) {
	deployer.deploy(
		ForbitswapRouterArtifacts,
		'0xaf6a570FD1D0a8Aff9c9EbAb67cc039dB5D58B59',
		'0xc778417E063141139Fce010982780140Aa0cD5Ab'
	);
};
