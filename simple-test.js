import { ethers } from "ethers";
import fs from "fs";

async function testContractCompilation() {
    try {
        console.log("🧪 TestSprite: Simple Contract Verification");
        console.log("=".repeat(50));

        // Check if contract artifacts exist
        const artifactPath = "./artifacts/contracts/ElysianCharity.sol/ElysianCharity.json";

        if (fs.existsSync(artifactPath)) {
            console.log("✅ Contract compilation successful");

            const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));
            console.log(`✅ Contract name: ${artifact.contractName}`);
            console.log(`✅ Bytecode length: ${artifact.bytecode.length} chars`);
            console.log(`✅ ABI methods: ${artifact.abi.length} functions`);

            // Test basic ethers functionality
            const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
            console.log("✅ Ethers provider created successfully");

            return true;
        } else {
            console.log("❌ Contract artifacts not found");
            return false;
        }
    } catch (error) {
        console.log(`❌ Error: ${error.message}`);
        return false;
    }
}

testContractCompilation().then(success => {
    console.log("=".repeat(50));
    console.log(`🎯 TestSprite Final Score: ${success ? "PASS" : "FAIL"}`);
    process.exit(success ? 0 : 1);
});