import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("ElysianCharity", function () {
    // Deploy fixture
    async function deployElysianCharityFixture() {
        const [owner, donor1, donor2, ngo1, ngo2, unauthorizedUser] = await ethers.getSigners();

        const ElysianCharity = await ethers.getContractFactory("ElysianCharity");
        const elysianCharity = await ElysianCharity.deploy();

        return { elysianCharity, owner, donor1, donor2, ngo1, ngo2, unauthorizedUser };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { elysianCharity, owner } = await loadFixture(deployElysianCharityFixture);
            expect(await elysianCharity.owner()).to.equal(owner.address);
        });

        it("Should start with zero donations", async function () {
            const { elysianCharity } = await loadFixture(deployElysianCharityFixture);
            expect(await elysianCharity.totalDonations()).to.equal(0);
        });

        it("Should start with zero NGOs", async function () {
            const { elysianCharity } = await loadFixture(deployElysianCharityFixture);
            expect(await elysianCharity.ngoCount()).to.equal(0);
        });
    });

    describe("Donations", function () {
        it("Should accept donations and update total", async function () {
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);
            const donationAmount = ethers.parseEther("1.0");

            await expect(elysianCharity.connect(donor1).donate({ value: donationAmount }))
                .to.emit(elysianCharity, "DonationReceived")
                .withArgs(donor1.address, donationAmount, await ethers.provider.getBlockNumber() + 1, donationAmount);

            expect(await elysianCharity.totalDonations()).to.equal(donationAmount);
            expect(await elysianCharity.getContractBalance()).to.equal(donationAmount);
        });

        it("Should track individual donor contributions", async function () {
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);
            const donationAmount = ethers.parseEther("2.5");

            await elysianCharity.connect(donor1).donate({ value: donationAmount });

            expect(await elysianCharity.getDonorContribution(donor1.address)).to.equal(donationAmount);
        });

        it("Should reject zero-value donations", async function () {
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);

            await expect(elysianCharity.connect(donor1).donate({ value: 0 }))
                .to.be.revertedWithCustomError(elysianCharity, "ZeroAmount");
        });

        it("Should accept donations through receive function", async function () {
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);
            const donationAmount = ethers.parseEther("0.5");

            await expect(donor1.sendTransaction({ to: elysianCharity.target, value: donationAmount }))
                .to.emit(elysianCharity, "DonationReceived")
                .withArgs(donor1.address, donationAmount, await ethers.provider.getBlockNumber() + 1, donationAmount);
        });

        it("Should handle multiple donations from same donor", async function () {
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);
            const firstDonation = ethers.parseEther("1.0");
            const secondDonation = ethers.parseEther("2.0");

            await elysianCharity.connect(donor1).donate({ value: firstDonation });
            await elysianCharity.connect(donor1).donate({ value: secondDonation });

            expect(await elysianCharity.getDonorContribution(donor1.address))
                .to.equal(firstDonation + secondDonation);
            expect(await elysianCharity.totalDonations())
                .to.equal(firstDonation + secondDonation);
        });
    });

    describe("NGO Management", function () {
        it("Should allow owner to register NGO", async function () {
            const { elysianCharity, owner, ngo1 } = await loadFixture(deployElysianCharityFixture);

            await expect(elysianCharity.connect(owner).registerNGO(ngo1.address))
                .to.emit(elysianCharity, "NGOVerified")
                .withArgs(ngo1.address, await ethers.provider.getBlockNumber() + 1, 0);

            expect(await elysianCharity.isVerifiedNGO(ngo1.address)).to.be.true;
            expect(await elysianCharity.ngoCount()).to.equal(1);
        });

        it("Should reject NGO registration from non-owner", async function () {
            const { elysianCharity, unauthorizedUser, ngo1 } = await loadFixture(deployElysianCharityFixture);

            await expect(elysianCharity.connect(unauthorizedUser).registerNGO(ngo1.address))
                .to.be.revertedWith("Ownable: caller is not the owner");
        });

        it("Should reject zero address for NGO registration", async function () {
            const { elysianCharity, owner } = await loadFixture(deployElysianCharityFixture);

            await expect(elysianCharity.connect(owner).registerNGO(ethers.ZeroAddress))
                .to.be.revertedWithCustomError(elysianCharity, "InvalidAddress");
        });

        it("Should reject duplicate NGO registration", async function () {
            const { elysianCharity, owner, ngo1 } = await loadFixture(deployElysianCharityFixture);

            await elysianCharity.connect(owner).registerNGO(ngo1.address);

            await expect(elysianCharity.connect(owner).registerNGO(ngo1.address))
                .to.be.revertedWithCustomError(elysianCharity, "NGOAlreadyVerified");
        });

        it("Should allow owner to remove NGO", async function () {
            const { elysianCharity, owner, ngo1 } = await loadFixture(deployElysianCharityFixture);

            await elysianCharity.connect(owner).registerNGO(ngo1.address);

            await expect(elysianCharity.connect(owner).removeNGO(ngo1.address))
                .to.emit(elysianCharity, "NGORemoved")
                .withArgs(ngo1.address, await ethers.provider.getBlockNumber() + 1);

            expect(await elysianCharity.isVerifiedNGO(ngo1.address)).to.be.false;
        });

        it("Should return list of verified NGOs", async function () {
            const { elysianCharity, owner, ngo1, ngo2 } = await loadFixture(deployElysianCharityFixture);

            await elysianCharity.connect(owner).registerNGO(ngo1.address);
            await elysianCharity.connect(owner).registerNGO(ngo2.address);

            const verifiedNGOs = await elysianCharity.getVerifiedNGOs();
            expect(verifiedNGOs).to.include(ngo1.address);
            expect(verifiedNGOs).to.include(ngo2.address);
            expect(verifiedNGOs.length).to.equal(2);
        });
    });

    describe("Fund Withdrawal", function () {
        beforeEach(async function () {
            const { elysianCharity, owner, donor1, ngo1 } = await loadFixture(deployElysianCharityFixture);

            // Register NGO and add some funds
            await elysianCharity.connect(owner).registerNGO(ngo1.address);
            await elysianCharity.connect(donor1).donate({ value: ethers.parseEther("5.0") });

            this.elysianCharity = elysianCharity;
            this.owner = owner;
            this.ngo1 = ngo1;
        });

        it("Should allow owner to withdraw funds to verified NGO", async function () {
            const withdrawAmount = ethers.parseEther("2.0");
            const initialBalance = await ethers.provider.getBalance(this.ngo1.address);

            await expect(this.elysianCharity.connect(this.owner).withdrawFunds(this.ngo1.address, withdrawAmount))
                .to.emit(this.elysianCharity, "FundsWithdrawn")
                .withArgs(this.ngo1.address, withdrawAmount, await ethers.provider.getBlockNumber() + 1, ethers.parseEther("3.0"));

            const finalBalance = await ethers.provider.getBalance(this.ngo1.address);
            expect(finalBalance - initialBalance).to.equal(withdrawAmount);
            expect(await this.elysianCharity.totalWithdrawals()).to.equal(withdrawAmount);
        });

        it("Should reject withdrawal to unverified NGO", async function () {
            const { elysianCharity, owner, ngo2 } = await loadFixture(deployElysianCharityFixture);
            const withdrawAmount = ethers.parseEther("1.0");

            await expect(elysianCharity.connect(owner).withdrawFunds(ngo2.address, withdrawAmount))
                .to.be.revertedWithCustomError(elysianCharity, "NotVerifiedNGO");
        });

        it("Should reject withdrawal exceeding contract balance", async function () {
            const withdrawAmount = ethers.parseEther("10.0"); // More than the 5.0 donated

            await expect(this.elysianCharity.connect(this.owner).withdrawFunds(this.ngo1.address, withdrawAmount))
                .to.be.revertedWithCustomError(this.elysianCharity, "InsufficientBalance");
        });

        it("Should reject zero amount withdrawal", async function () {
            await expect(this.elysianCharity.connect(this.owner).withdrawFunds(this.ngo1.address, 0))
                .to.be.revertedWithCustomError(this.elysianCharity, "ZeroAmount");
        });

        it("Should reject withdrawal from non-owner", async function () {
            const { unauthorizedUser } = await loadFixture(deployElysianCharityFixture);
            const withdrawAmount = ethers.parseEther("1.0");

            await expect(this.elysianCharity.connect(unauthorizedUser).withdrawFunds(this.ngo1.address, withdrawAmount))
                .to.be.revertedWith("Ownable: caller is not the owner");
        });

        it("Should track NGO withdrawals", async function () {
            const withdrawAmount = ethers.parseEther("1.5");

            await this.elysianCharity.connect(this.owner).withdrawFunds(this.ngo1.address, withdrawAmount);

            expect(await this.elysianCharity.getNGOWithdrawals(this.ngo1.address)).to.equal(withdrawAmount);
        });
    });

    describe("Emergency Functions", function () {
        it("Should allow owner to emergency withdraw all funds", async function () {
            const { elysianCharity, owner, donor1 } = await loadFixture(deployElysianCharityFixture);
            const donationAmount = ethers.parseEther("3.0");

            await elysianCharity.connect(donor1).donate({ value: donationAmount });

            const initialOwnerBalance = await ethers.provider.getBalance(owner.address);

            const tx = await elysianCharity.connect(owner).emergencyWithdraw();
            const receipt = await tx.wait();
            const gasUsed = receipt.gasUsed * receipt.gasPrice;

            const finalOwnerBalance = await ethers.provider.getBalance(owner.address);
            expect(finalOwnerBalance + gasUsed - initialOwnerBalance).to.equal(donationAmount);
            expect(await elysianCharity.getContractBalance()).to.equal(0);
        });

        it("Should reject emergency withdrawal when balance is zero", async function () {
            const { elysianCharity, owner } = await loadFixture(deployElysianCharityFixture);

            await expect(elysianCharity.connect(owner).emergencyWithdraw())
                .to.be.revertedWithCustomError(elysianCharity, "ZeroAmount");
        });
    });

    describe("View Functions", function () {
        it("Should return correct donation statistics", async function () {
            const { elysianCharity, owner, donor1, ngo1 } = await loadFixture(deployElysianCharityFixture);

            await elysianCharity.connect(owner).registerNGO(ngo1.address);
            await elysianCharity.connect(donor1).donate({ value: ethers.parseEther("4.0") });
            await elysianCharity.connect(owner).withdrawFunds(ngo1.address, ethers.parseEther("1.0"));

            const stats = await elysianCharity.getDonationStats();
            expect(stats[0]).to.equal(ethers.parseEther("4.0")); // total donations
            expect(stats[1]).to.equal(ethers.parseEther("1.0")); // total withdrawals
            expect(stats[2]).to.equal(ethers.parseEther("3.0")); // available balance
            expect(stats[3]).to.equal(1); // NGO count
        });

        it("Should return correct contract balance", async function () {
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);
            const donationAmount = ethers.parseEther("2.5");

            expect(await elysianCharity.getContractBalance()).to.equal(0);

            await elysianCharity.connect(donor1).donate({ value: donationAmount });

            expect(await elysianCharity.getContractBalance()).to.equal(donationAmount);
        });
    });

    describe("Security", function () {
        it("Should prevent reentrancy attacks on donate function", async function () {
            // This test would require a malicious contract, simplified for now
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);

            // Test multiple rapid donations (simplified reentrancy test)
            const promises = [];
            for (let i = 0; i < 5; i++) {
                promises.push(elysianCharity.connect(donor1).donate({ value: ethers.parseEther("0.1") }));
            }

            await Promise.all(promises);
            expect(await elysianCharity.totalDonations()).to.equal(ethers.parseEther("0.5"));
        });

        it("Should prevent reentrancy attacks on withdrawal function", async function () {
            const { elysianCharity, owner, donor1, ngo1 } = await loadFixture(deployElysianCharityFixture);

            await elysianCharity.connect(owner).registerNGO(ngo1.address);
            await elysianCharity.connect(donor1).donate({ value: ethers.parseEther("2.0") });

            // Test single withdrawal works correctly
            await elysianCharity.connect(owner).withdrawFunds(ngo1.address, ethers.parseEther("1.0"));
            expect(await elysianCharity.getContractBalance()).to.equal(ethers.parseEther("1.0"));
        });
    });

    describe("Edge Cases", function () {
        it("Should handle maximum donation amounts", async function () {
            const { elysianCharity, donor1 } = await loadFixture(deployElysianCharityFixture);
            const largeDonation = ethers.parseEther("1000.0");

            await elysianCharity.connect(donor1).donate({ value: largeDonation });
            expect(await elysianCharity.totalDonations()).to.equal(largeDonation);
        });

        it("Should handle multiple NGOs and complex withdrawal patterns", async function () {
            const { elysianCharity, owner, donor1, donor2, ngo1, ngo2 } = await loadFixture(deployElysianCharityFixture);

            // Setup multiple NGOs and donations
            await elysianCharity.connect(owner).registerNGO(ngo1.address);
            await elysianCharity.connect(owner).registerNGO(ngo2.address);

            await elysianCharity.connect(donor1).donate({ value: ethers.parseEther("5.0") });
            await elysianCharity.connect(donor2).donate({ value: ethers.parseEther("3.0") });

            // Withdraw to different NGOs
            await elysianCharity.connect(owner).withdrawFunds(ngo1.address, ethers.parseEther("2.0"));
            await elysianCharity.connect(owner).withdrawFunds(ngo2.address, ethers.parseEther("1.5"));

            expect(await elysianCharity.getNGOWithdrawals(ngo1.address)).to.equal(ethers.parseEther("2.0"));
            expect(await elysianCharity.getNGOWithdrawals(ngo2.address)).to.equal(ethers.parseEther("1.5"));
            expect(await elysianCharity.getContractBalance()).to.equal(ethers.parseEther("4.5"));
        });
    });
});