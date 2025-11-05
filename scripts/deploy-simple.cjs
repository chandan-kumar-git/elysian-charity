const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying ElysianCharity contract...");

  // Get the deployer account
  const [deployer] = await hre.ethers.getSigners();
  console.log("📝 Deploying with account:", deployer.address);
  
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
  console.log("💰 Total Donations:", hre.ethers.formatEther(totalDonations), "ETH");
  console.log("🏦 Contract Balance:", hre.ethers.formatEther(contractBalance), "ETH");

  console.log("\n🔧 Frontend Configuration:");
  console.log("Add to your .env.local:");
  console.log(`NEXT_PUBLIC_CONTRACT_ADDRESS=${contractAddress}`);
  console.log(`NEXT_PUBLIC_OWNER_ADDRESS=${await elysianCharity.owner()}`);

  return {
    contractAddress,
    owner: await elysianCharity.owner(),
    deployer: deployer.address
  };
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });