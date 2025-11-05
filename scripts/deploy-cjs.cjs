const hre = require("hardhat");

async function main() {
    console.log("🚀 Starting deployment of ElysianCharity contract...");

    // Get the deployer account
    const [deployer] = await hre.ethers.getSigners();
    console.log("📝 Deploying contracts with account:", deployer.address);

    // Get account balance
    const balance = await hre.ethers.provider.getBalance(deployer.address);
    console.log("💰 Account balance:", hre.ethers.formatEther(balance), "ETH");

    // Deploy the contract
    const ElysianCharity = await hre.ethers.getContractFactory("ElysianCharity");
    console.log("⏳ Deploying contract...");

    const elysianCharity = await ElysianCharity.deploy();
    await elysianCharity.waitForDeployment();

    const contractAddress = await elysianCharity.getAddress();
    console.log("✅ ElysianCharity deployed to:", contractAddress);
    console.log("👤 Contract owner:", await elysianCharity.owner());

    // Verify deployment
    console.log("\n🔍 Verifying deployment...");
    const totalDonations = await elysianCharity.getTotalDonations();
    const contractBalance = await elysianCharity.getContractBalance();

    console.log("📊 Initial state:");
    console.log("- Total donations:", hre.ethers.formatEther(totalDonations), "ETH");
    console.log("- Contract balance:", hre.ethers.formatEther(contractBalance), "ETH");

    console.log("\n🔧 Environment variables for frontend:");
    console.log(`NEXT_PUBLIC_CONTRACT_ADDRESS=${contractAddress}`);
    console.log(`NEXT_PUBLIC_OWNER_ADDRESS=${deployer.address}`);

    return {
        contractAddress,
        ownerAddress: deployer.address,
        totalDonations: hre.ethers.formatEther(totalDonations),
        contractBalance: hre.ethers.formatEther(contractBalance)
    };
}

// Run deployment
main()
    .then((result) => {
        console.log("\n✅ Deployment completed successfully!");
        console.log("📋 Summary:", result);
        process.exit(0);
    })
    .catch((error) => {
        console.error("❌ Deployment failed:", error);
        process.exit(1);
    });