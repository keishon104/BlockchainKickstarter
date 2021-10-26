const { compile } = require('solc');
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/CampaignFactory.json');

const provider = new HDWalletProvider(
    // Mnemonic phrase
    'much record use pioneer good deal kind yard account thing foil congress',
    // Endpoint link to rinkeby chain. 
    'https://rinkeby.infura.io/v3/5dd8508da13144be9a61fbd4281737bb'
);
const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log("Attempting to deploy from", accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({data: compiledFactory.bytecode})
    .send({gas:'1000000', from: accounts[0]});

    console.log("Contract address", result.options.address);
};

deploy();