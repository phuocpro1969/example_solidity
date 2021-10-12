const ForbitswapFactoryArtifacts = artifacts.require('ForbitswapFactory');

module.exports = async function (deployer) {
	await deployer
		.deploy(ForbitswapFactoryArtifacts, '0x8b578deb4e2a5cfb0a00277e9ef8b0fef566512b')
		.then(async (result) =>
			console.log('INIT_CODE_PAIR_HASH: ', await result.INIT_CODE_PAIR_HASH.call())
		);
};
