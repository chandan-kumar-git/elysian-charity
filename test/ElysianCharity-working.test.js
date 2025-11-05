const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("🏆 ElysianCharity - Complete Test Suite", function () {
    let elysianCharity;
    let owner;
    let ngo1;
    let ngo2;
    let donor1;
    let donor2;

    beforeEach(async function () {
        [owner, ngo1, ngo2, donor1, donor2] = await ethers.getSigners();

        const ElysianCharity = await ethers.getContractFactory("ElysianCharity");
        elysianCharity = await ElysianCharity.deploy();
        await elysianCharity.waitForDeployment();
    });

    describe("🚀 Deployment & Initialization", function () {
        it("Should deploy with correct owner", async function () {
            expect(await elysianCharity.owner()).to.equal(owner.address);
        });

        it("Should start unpaused", async function () {
            expect(await elysianCharity.paused()).to.be.false;
        });

        it("Should have zero initial counts", async function () {
            expect(await elysianCharity.getDonationsCount()).to.equal(0);
            expect(await elysianCharity.getVerifiedNGOsCount()).to.equal(0);
        });
    });

    describe("🏢 NGO Management", function () {
        it("Should allow owner to verify NGO", async function () {
            await expect(
                elysianCharity.verifyNGO(ngo1.address, "Red Cross")
            ).to.emit(elysianCharity, "NGOVerified")
                .withArgs(ngo1.address, "Red Cross");

            expect(await elysianCharity.verifiedNGOs(ngo1.address)).to.be.true;
            expect(await elysianCharity.getVerifiedNGOsCount()).to.equal(1);
        });

        it("Should not allow non-owner to verify NGO", async function () {
            await expect(
                elysianCharity.connect(donor1).verifyNGO(ngo1.address, "Red Cross")
            ).to.be.revertedWithCustomError(elysianCharity, "OwnableUnauthorizedAccount");
        });

        it("Should allow owner to remove NGO", async function () {
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");

            await expect(
                elysianCharity.removeNGO(ngo1.address)
            ).to.emit(elysianCharity, "NGORemoved")
                .withArgs(ngo1.address);

            expect(await elysianCharity.verifiedNGOs(ngo1.address)).to.be.false;
        });

        it("Should prevent verifying same NGO twice", async function () {
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");

            await expect(
                elysianCharity.verifyNGO(ngo1.address, "Red Cross")
            ).to.be.revertedWith("NGO already verified");
        });
    });

    describe("💰 Donation System", function () {
        beforeEach(async function () {
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");
        });

        it("Should accept donations to verified NGO", async function () {
            const donationAmount = ethers.parseEther("1.0");

            await expect(
                elysianCharity.connect(donor1).donate(ngo1.address, { value: donationAmount })
            ).to.emit(elysianCharity, "DonationReceived")
                .withArgs(donor1.address, ngo1.address, donationAmount);

            expect(await elysianCharity.getDonationsCount()).to.equal(1);
        });

        it("Should reject donations to unverified NGO", async function () {
            const donationAmount = ethers.parseEther("1.0");

            await expect(
                elysianCharity.connect(donor1).donate(ngo2.address, { value: donationAmount })
            ).to.be.revertedWith("NGO not verified");
        });

        it("Should reject zero amount donations", async function () {
            await expect(
                elysianCharity.connect(donor1).donate(ngo1.address, { value: 0 })
            ).to.be.revertedWith("Donation amount must be greater than 0");
        });

        it("Should track multiple donations correctly", async function () {
            const amount1 = ethers.parseEther("1.0");
            const amount2 = ethers.parseEther("2.0");

            await elysianCharity.connect(donor1).donate(ngo1.address, { value: amount1 });
            await elysianCharity.connect(donor2).donate(ngo1.address, { value: amount2 });

            expect(await elysianCharity.getDonationsCount()).to.equal(2);
        });
    });

    describe("💸 Fund Withdrawal", function () {
        beforeEach(async function () {
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");
            await elysianCharity.connect(donor1).donate(ngo1.address, { value: ethers.parseEther("2.0") });
        });

        it("Should allow NGO to withdraw funds", async function () {
            const withdrawAmount = ethers.parseEther("1.0");

            await expect(
                elysianCharity.connect(ngo1).withdrawFunds(withdrawAmount)
            ).to.emit(elysianCharity, "FundsWithdrawn")
                .withArgs(ngo1.address, withdrawAmount);
        });

        it("Should not allow withdrawal of more than available", async function () {
            const excessiveAmount = ethers.parseEther("10.0");

            await expect(
                elysianCharity.connect(ngo1).withdrawFunds(excessiveAmount)
            ).to.be.revertedWith("Insufficient funds");
        });

        it("Should not allow unverified NGO to withdraw", async function () {
            const withdrawAmount = ethers.parseEther("1.0");

            await expect(
                elysianCharity.connect(ngo2).withdrawFunds(withdrawAmount)
            ).to.be.revertedWith("NGO not verified");
        });
    });

    describe("⏸️ Emergency Controls", function () {
        it("Should allow owner to pause contract", async function () {
            await elysianCharity.pause();
            expect(await elysianCharity.paused()).to.be.true;
        });

        it("Should allow owner to unpause contract", async function () {
            await elysianCharity.pause();
            await elysianCharity.unpause();
            expect(await elysianCharity.paused()).to.be.false;
        });

        it("Should prevent donations when paused", async function () {
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");
            await elysianCharity.pause();

            await expect(
                elysianCharity.connect(donor1).donate(ngo1.address, { value: ethers.parseEther("1.0") })
            ).to.be.revertedWithCustomError(elysianCharity, "EnforcedPause");
        });
    });

    describe("📊 Data Retrieval", function () {
        beforeEach(async function () {
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");
            await elysianCharity.verifyNGO(ngo2.address, "UNICEF");
            await elysianCharity.connect(donor1).donate(ngo1.address, { value: ethers.parseEther("1.0") });
            await elysianCharity.connect(donor2).donate(ngo2.address, { value: ethers.parseEther("2.0") });
        });

        it("Should return correct donation count", async function () {
            expect(await elysianCharity.getDonationsCount()).to.equal(2);
        });

        it("Should return correct NGO count", async function () {
            expect(await elysianCharity.getVerifiedNGOsCount()).to.equal(2);
        });

        it("Should return donation details", async function () {
            const donation = await elysianCharity.donations(0);
            expect(donation.donor).to.equal(donor1.address);
            expect(donation.ngo).to.equal(ngo1.address);
            expect(donation.amount).to.equal(ethers.parseEther("1.0"));
        });
    });

    describe("🔒 Security Features", function () {
        it("Should handle zero address properly", async function () {
            await expect(
                elysianCharity.verifyNGO(ethers.ZeroAddress, "Invalid NGO")
            ).to.be.revertedWith("Invalid NGO address");
        });

        it("Should handle empty name properly", async function () {
            await expect(
                elysianCharity.verifyNGO(ngo1.address, "")
            ).to.be.revertedWith("NGO name cannot be empty");
        });
    });

    describe("🎯 Real-world Scenarios", function () {
        it("Should handle complex donation and withdrawal flow", async function () {
            // Setup multiple NGOs
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");
            await elysianCharity.verifyNGO(ngo2.address, "UNICEF");

            // Multiple donations
            await elysianCharity.connect(donor1).donate(ngo1.address, { value: ethers.parseEther("3.0") });
            await elysianCharity.connect(donor2).donate(ngo1.address, { value: ethers.parseEther("2.0") });
            await elysianCharity.connect(donor1).donate(ngo2.address, { value: ethers.parseEther("1.5") });

            // Verify total donations
            expect(await elysianCharity.getDonationsCount()).to.equal(3);

            // Partial withdrawals
            await elysianCharity.connect(ngo1).withdrawFunds(ethers.parseEther("2.0"));
            await elysianCharity.connect(ngo2).withdrawFunds(ethers.parseEther("1.0"));

            // Should still have remaining funds
            expect(await ethers.provider.getBalance(elysianCharity.target)).to.equal(ethers.parseEther("3.5"));
        });

        it("Should handle NGO verification and removal cycle", async function () {
            // Verify NGO
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");
            expect(await elysianCharity.getVerifiedNGOsCount()).to.equal(1);

            // Donate to NGO
            await elysianCharity.connect(donor1).donate(ngo1.address, { value: ethers.parseEther("1.0") });

            // Remove NGO
            await elysianCharity.removeNGO(ngo1.address);
            expect(await elysianCharity.getVerifiedNGOsCount()).to.equal(0);

            // Should not be able to donate anymore
            await expect(
                elysianCharity.connect(donor1).donate(ngo1.address, { value: ethers.parseEther("1.0") })
            ).to.be.revertedWith("NGO not verified");
        });
    });

    describe("📈 Gas Optimization Tests", function () {
        it("Should have reasonable gas costs for donations", async function () {
            await elysianCharity.verifyNGO(ngo1.address, "Red Cross");

            const tx = await elysianCharity.connect(donor1).donate(ngo1.address, { value: ethers.parseEther("1.0") });
            const receipt = await tx.wait();

            // Gas should be reasonable (less than 100k for donation)
            expect(receipt.gasUsed).to.be.lt(100000);
            console.log(`      ⛽ Donation gas used: ${receipt.gasUsed.toString()}`);
        });

        it("Should have reasonable gas costs for NGO verification", async function () {
            const tx = await elysianCharity.verifyNGO(ngo1.address, "Red Cross");
            const receipt = await tx.wait();

            // Gas should be reasonable (less than 100k for verification)
            expect(receipt.gasUsed).to.be.lt(100000);
            console.log(`      ⛽ NGO verification gas used: ${receipt.gasUsed.toString()}`);
        });
    });
});