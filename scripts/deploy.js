import { ethers } from "hardhat";

async function main() {
    console.log("🚀 Deploying ElysianCharity contract...");

    // Get the deployer account
    const [deployer] = await ethers.getSigners();
    console.log("📝 Deploying contracts with account:", deployer.address);

    // Get account balance
    const balance = await ethers.provider.getBalance(deployer.address);
    console.log("💰 Account balance:", ethers.formatEther(balance), "ETH");

    // Deploy the contract
    const ElysianCharity = await ethers.getContractFactory("ElysianCharity");
    console.log("⏳ Deploying contract...");

    const elysianCharity = await ElysianCharity.deploy();
    await elysianCharity.waitForDeployment();

    const contractAddress = await elysianCharity.getAddress();
    console.log("✅ ElysianCharity deployed to:", contractAddress);
    console.log("👤 Contract owner:", await elysianCharity.owner());

    // Verify deployment
    console.log("\n🔍 Verifying deployment...");
    const totalDonations = await elysianCharity.totalDonations();
    const ngoCount = await elysianCharity.ngoCount();
    const contractBalance = await elysianCharity.getContractBalance();

    console.log("📊 Initial state:");
    console.log("  - Total donations:", ethers.formatEther(totalDonations), "ETH");
    console.log("  - NGO count:", ngoCount.toString());
    console.log("  - Contract balance:", ethers.formatEther(contractBalance), "ETH");

    // Save deployment info
    const deploymentInfo = {
        network: hre.network.name,
        contractAddress: contractAddress,
        ownerAddress: deployer.address,
        deploymentBlock: await ethers.provider.getBlockNumber(),
        timestamp: new Date().toISOString(),
        gasUsed: "Calculating...",
    };

    console.log("\n📋 Deployment Summary:");
    console.log("=====================================");
    console.log(`Network: ${deploymentInfo.network}`);
    console.log(`Contract Address: ${deploymentInfo.contractAddress}`);
    console.log(`Owner Address: ${deploymentInfo.ownerAddress}`);
    console.log(`Block Number: ${deploymentInfo.deploymentBlock}`);
    console.log(`Timestamp: ${deploymentInfo.timestamp}`);
    console.log("=====================================");

    // Create frontend environment variables
    console.log("\n📝 Frontend Environment Variables:");
    console.log("Add these to your .env.local file:");
    console.log("=====================================");
    console.log(`NEXT_PUBLIC_CONTRACT_ADDRESS=${contractAddress}`);
    console.log(`NEXT_PUBLIC_OWNER_ADDRESS=${deployer.address}`);
    console.log(`NEXT_PUBLIC_NETWORK_NAME=${hre.network.name}`);
    console.log("=====================================");

    // Save to file for frontend
    const fs = require('fs');
    const deploymentData = {
        ...deploymentInfo,
        abi: ElysianCharity.interface.formatJson()
    };

    fs.writeFileSync(
        './deployment-info.json',
        JSON.stringify(deploymentData, null, 2)
    );
    console.log("\n💾 Deployment info saved to deployment-info.json");

    // Instructions for verification on Etherscan
    if (hre.network.name !== "hardhat" && hre.network.name !== "localhost") {
        console.log("\n🔍 To verify on Etherscan, run:");
        console.log(`npx hardhat verify --network ${hre.network.name} ${contractAddress}`);
    }

    console.log("\n🎉 Deployment completed successfully!");
    return contractAddress;
}

// Handle errors
main()
    .then((contractAddress) => {
        console.log(`\n✨ Contract deployed at: ${contractAddress}`);
        process.exit(0);
    })
    .catch((error) => {
        console.error("❌ Deployment failed:");
        console.error(error);
        process.exit(1);
    });