const OaxisToken = artifacts.require('p1Token');
const p1Token = artifacts.require('p1Token');

module.exports = async function (deployer) {
	await deployer.deploy(OaxisToken, 2000000000);
	await OaxisToken.deployed();
	await deployer.deploy(p1Token, 2000000000);
	await p1Token.deployed();
};
