const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
    console.log("🚀 Starting Elysian Charity Contract Deployment...\n");

    try {
        // Get network info
        const network = await ethers.provider.getNetwork();
        console.log(`📡 Network: ${network.name} (Chain ID: ${network.chainId})`);

        // Get deployer account
        const [deployer] = await ethers.getSigners();
        const deployerAddress = await deployer.getAddress();
        console.log(`👤 Deployer: ${deployerAddress}`);

        // Check balance
        const balance = await deployer.provider.getBalance(deployerAddress);
        console.log(`💰 Balance: ${ethers.formatEther(balance)} ETH\n`);

        if (balance === 0n) {
            console.error("❌ Deployer has no ETH! Please fund the account.");
            process.exit(1);
        }

        // Deploy contract
        console.log("📝 Deploying ElysianCharity contract...");
        const ElysianCharity = await ethers.getContractFactory("ElysianCharity");

        // Estimate gas
        const deploymentData = ElysianCharity.interface.encodeDeploy([]);
        const gasEstimate = await deployer.estimateGas({
            data: deploymentData
        });
        console.log(`⛽ Estimated Gas: ${gasEstimate.toString()}`);

        // Deploy with gas limit
        const contract = await ElysianCharity.deploy({
            gasLimit: gasEstimate * 120n / 100n // 20% buffer
        });

        console.log(`⏳ Transaction hash: ${contract.deploymentTransaction().hash}`);
        console.log("🔄 Waiting for deployment confirmation...");

        // Wait for deployment
        const deployedContract = await contract.waitForDeployment();
        const contractAddress = await deployedContract.getAddress();

        console.log(`\n✅ Contract deployed successfully!`);
        console.log(`📍 Contract Address: ${contractAddress}`);
        console.log(`👑 Owner Address: ${deployerAddress}`);

        // Verify deployment
        console.log("\n🔍 Verifying deployment...");
        const owner = await deployedContract.owner();
        const isOwnerCorrect = owner.toLowerCase() === deployerAddress.toLowerCase();

        if (isOwnerCorrect) {
            console.log("✅ Owner verification: PASSED");
        } else {
            console.log("❌ Owner verification: FAILED");
            console.log(`Expected: ${deployerAddress}`);
            console.log(`Got: ${owner}`);
        }

        // Test basic functionality
        console.log("\n🧪 Testing basic functionality...");

        // Check if contract is not paused
        const isPaused = await deployedContract.paused();
        console.log(`📊 Contract paused status: ${isPaused}`);

        // Test donation count (should be 0)
        const donationCount = await deployedContract.getDonationsCount();
        console.log(`📈 Initial donation count: ${donationCount}`);

        // Test NGO count (should be 0)
        const ngoCount = await deployedContract.getVerifiedNGOsCount();
        console.log(`🏢 Initial NGO count: ${ngoCount}`);

        // Create environment file for frontend
        const envContent = `# Elysian Charity dApp Configuration
# Generated on: ${new Date().toISOString()}

NEXT_PUBLIC_CONTRACT_ADDRESS=${contractAddress}
NEXT_PUBLIC_OWNER_ADDRESS=${deployerAddress}
NEXT_PUBLIC_NETWORK_NAME=${network.name === "unknown" ? "localhost" : network.name}
NEXT_PUBLIC_CHAIN_ID=${network.chainId}

# Optional: Add RPC URLs for different networks
# NEXT_PUBLIC_SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_KEY
# NEXT_PUBLIC_MAINNET_RPC_URL=https://mainnet.infura.io/v3/YOUR_KEY
`;

        const envPath = path.join(__dirname, "..", "frontend", ".env.local");
        fs.writeFileSync(envPath, envContent);
        console.log(`📁 Environment file created: frontend/.env.local`);

        // Create deployment info file
        const deploymentInfo = {
            contractAddress,
            ownerAddress: deployerAddress,
            networkName: network.name === "unknown" ? "localhost" : network.name,
            chainId: Number(network.chainId),
            deploymentHash: contract.deploymentTransaction().hash,
            timestamp: new Date().toISOString(),
            gasUsed: gasEstimate.toString(),
            balance: ethers.formatEther(balance)
        };

        const deploymentPath = path.join(__dirname, "..", "deployment-info.json");
        fs.writeFileSync(deploymentPath, JSON.stringify(deploymentInfo, null, 2));
        console.log(`📊 Deployment info saved: deployment-info.json`);

        // Success summary
        console.log("\n🎉 DEPLOYMENT COMPLETED SUCCESSFULLY!");
        console.log("=" * 50);
        console.log(`📍 Contract: ${contractAddress}`);
        console.log(`👑 Owner: ${deployerAddress}`);
        console.log(`🌐 Network: ${network.name} (${network.chainId})`);
        console.log(`⛽ Gas Used: ~${gasEstimate.toString()}`);
        console.log("=" * 50);

        console.log("\n📋 NEXT STEPS:");
        console.log("1. Start the frontend: cd frontend && npm run dev");
        console.log("2. Open browser: http://localhost:3000");
        console.log("3. Connect MetaMask to the correct network");
        console.log("4. Start testing the dApp!");

        if (network.name === "unknown") {
            console.log("\n⚠️  LOCALHOST SETUP:");
            console.log("- Make sure Hardhat node is running: npx hardhat node");
            console.log("- Add localhost network to MetaMask:");
            console.log("  - Network: Localhost 8545");
            console.log("  - RPC: http://127.0.0.1:8545");
            console.log("  - Chain ID: 31337");
            console.log("  - Currency: ETH");
        }

    } catch (error) {
        console.error("\n❌ DEPLOYMENT FAILED!");
        console.error("Error:", error.message);

        if (error.message.includes("insufficient funds")) {
            console.error("\n💡 SOLUTION: Fund your deployer account with ETH");
        } else if (error.message.includes("network")) {
            console.error("\n💡 SOLUTION: Check network configuration in hardhat.config.js");
        } else if (error.message.includes("compilation")) {
            console.error("\n💡 SOLUTION: Run 'npx hardhat compile' first");
        }

        process.exit(1);
    }
}

// Error handling
process.on('unhandledRejection', (error) => {
    console.error('\n❌ Unhandled promise rejection:', error);
    process.exit(1);
});

process.on('uncaughtException', (error) => {
    console.error('\n❌ Uncaught exception:', error);
    process.exit(1);
});

if (require.main === module) {
    main()
        .then(() => process.exit(0))
        .catch((error) => {
            console.error('\n❌ Script execution failed:', error);
            process.exit(1);
        });
}

module.exports = { main };