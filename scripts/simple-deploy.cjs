// Simple contract deployment using pure ethers.js
const { ethers } = require('ethers');
const fs = require('fs');
const path = require('path');

async function deployContract() {
    console.log('🚀 Starting contract deployment...');
    
    // Connect to Hardhat local network
    const provider = new ethers.JsonRpcProvider('http://127.0.0.1:8545');
    
    // Use the first account from Hardhat
    const privateKey = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';
    const wallet = new ethers.Wallet(privateKey, provider);
    
    console.log('📝 Deploying with account:', wallet.address);
    
    // Read compiled contract
    const contractPath = path.join(__dirname, '../artifacts/contracts/ElysianCharity.sol/ElysianCharity.json');
    const contractJSON = JSON.parse(fs.readFileSync(contractPath, 'utf8'));
    
    // Create contract factory
    const contractFactory = new ethers.ContractFactory(
        contractJSON.abi,
        contractJSON.bytecode,
        wallet
    );
    
    // Deploy the contract
    console.log('⏳ Deploying contract...');
    const contract = await contractFactory.deploy();
    await contract.waitForDeployment();
    
    const contractAddress = await contract.getAddress();
    console.log('✅ Contract deployed to:', contractAddress);
    console.log('👤 Owner address:', wallet.address);
    
    // Verify deployment
    const owner = await contract.owner();
    const totalDonations = await contract.getTotalDonations();
    const contractBalance = await contract.getContractBalance();
    
    console.log('\n📊 Contract Info:');
    console.log('- Contract Address:', contractAddress);
    console.log('- Owner:', owner);
    console.log('- Total Donations:', ethers.formatEther(totalDonations), 'ETH');
    console.log('- Contract Balance:', ethers.formatEther(contractBalance), 'ETH');
    
    console.log('\n🔧 Environment Variables:');
    console.log(`NEXT_PUBLIC_CONTRACT_ADDRESS=${contractAddress}`);
    console.log(`NEXT_PUBLIC_OWNER_ADDRESS=${wallet.address}`);
    
    return contractAddress;
}

deployContract()
    .then((address) => {
        console.log('\n✅ Deployment successful!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('❌ Deployment failed:', error);
        process.exit(1);
    });