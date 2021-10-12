const HDWalletProvider = require('@truffle/hdwallet-provider');
const mnemonic = 'tuition umbrella mansion absurd slice plate armed number flight steak thank want';

module.exports = {
	networks: {
		development: {
			host: '127.0.0.1',
			port: 7545,
			network_id: '5777',
			gas: 6721975,
			gasPrice: 2000000000,
			websocket: true,
		},
		rinkeby: {
			provider: () =>
				new HDWalletProvider(
					mnemonic,
					`https://rinkeby.infura.io/v3/d730916eb456447c9f545868c6c1573d`
				),
			network_id: 4,
			gas: 10000000,
			//confirmations: 2,
			timeoutBlocks: 200,
			from: '0x8B578Deb4e2A5CFB0A00277E9ef8B0feF566512B',
			skipDryRun: true,
		},
	},

	mocha: {
		// timeout: 100000
	},

	compilers: {
		solc: {
			version: '0.5.17',
			// docker: true,
			settings: {
				optimizer: {
					enabled: true,
					runs: 200,
				},
				// evmVersion: 'byzantium',
			},
		},
	},

	db: {
		enabled: false,
	},
};
