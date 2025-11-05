// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ElysianCharity
 * @dev A transparent charity donation system with NGO verification and fund tracking
 * @author GitHub Copilot Pro & Team
 */
contract ElysianCharity is ReentrancyGuard, Ownable {
    // State Variables
    mapping(address => bool) public verifiedNGOs;
    uint256 public totalDonations;
    uint256 public totalWithdrawals;
    uint256 public ngoCount;
    
    // Additional tracking for enhanced transparency
    mapping(address => uint256) public donorContributions;
    mapping(address => uint256) public ngoWithdrawals;
    address[] public ngoList;
    
    // Events (For Transparency and Indexing)
    event DonationReceived(
        address indexed donor, 
        uint256 amount, 
        uint256 timestamp,
        uint256 newTotalDonations
    );
    
    event NGOVerified(
        address indexed ngoAddress, 
        uint256 timestamp,
        uint256 ngoIndex
    );
    
    event FundsWithdrawn(
        address indexed recipient, 
        uint256 amount, 
        uint256 timestamp,
        uint256 remainingBalance
    );
    
    event NGORemoved(
        address indexed ngoAddress,
        uint256 timestamp
    );

    // Custom Errors for Gas Optimization
    error NotVerifiedNGO();
    error InsufficientBalance();
    error ZeroAmount();
    error InvalidAddress();
    error NGOAlreadyVerified();
    error NGONotFound();

    /**
     * @dev Constructor sets the deployer as the owner
     */
    constructor() Ownable(msg.sender) {
        // Owner is set by Ownable constructor with msg.sender parameter
    }

    /**
     * @dev Allows users to donate ETH to the charity
     * @notice Anyone can donate any amount > 0
     */
    function donate() external payable nonReentrant {
        if (msg.value == 0) revert ZeroAmount();
        
        totalDonations += msg.value;
        donorContributions[msg.sender] += msg.value;
        
        emit DonationReceived(
            msg.sender, 
            msg.value, 
            block.timestamp,
            totalDonations
        );
    }

    /**
     * @dev Register a new NGO address for fund withdrawal
     * @param _ngoAddress The address of the NGO to verify
     */
    function registerNGO(address _ngoAddress) external onlyOwner {
        if (_ngoAddress == address(0)) revert InvalidAddress();
        if (verifiedNGOs[_ngoAddress]) revert NGOAlreadyVerified();
        
        verifiedNGOs[_ngoAddress] = true;
        ngoList.push(_ngoAddress);
        ngoCount++;
        
        emit NGOVerified(_ngoAddress, block.timestamp, ngoCount - 1);
    }

    /**
     * @dev Remove an NGO from the verified list
     * @param _ngoAddress The address of the NGO to remove
     */
    function removeNGO(address _ngoAddress) external onlyOwner {
        if (!verifiedNGOs[_ngoAddress]) revert NGONotFound();
        
        verifiedNGOs[_ngoAddress] = false;
        
        // Remove from array (optional - for gas optimization)
        for (uint256 i = 0; i < ngoList.length; i++) {
            if (ngoList[i] == _ngoAddress) {
                ngoList[i] = ngoList[ngoList.length - 1];
                ngoList.pop();
                ngoCount--;
                break;
            }
        }
        
        emit NGORemoved(_ngoAddress, block.timestamp);
    }

    /**
     * @dev Withdraw funds to a verified NGO
     * @param _ngoAddress The verified NGO address to receive funds
     * @param _amount The amount to withdraw in wei
     */
    function withdrawFunds(address _ngoAddress, uint256 _amount) 
        external 
        onlyOwner 
        nonReentrant 
    {
        if (!verifiedNGOs[_ngoAddress]) revert NotVerifiedNGO();
        if (_amount == 0) revert ZeroAmount();
        if (address(this).balance < _amount) revert InsufficientBalance();
        
        totalWithdrawals += _amount;
        ngoWithdrawals[_ngoAddress] += _amount;
        
        // Use call for safer ETH transfer
        (bool success, ) = _ngoAddress.call{value: _amount}("");
        require(success, "Transfer failed");
        
        emit FundsWithdrawn(
            _ngoAddress, 
            _amount, 
            block.timestamp,
            address(this).balance
        );
    }

    /**
     * @dev Emergency withdrawal - only owner can withdraw all funds
     */
    function emergencyWithdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        if (balance == 0) revert ZeroAmount();
        
        totalWithdrawals += balance;
        
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Emergency withdrawal failed");
        
        emit FundsWithdrawn(
            owner(), 
            balance, 
            block.timestamp,
            0
        );
    }

    // View Functions for Frontend Integration
    
    /**
     * @dev Get contract balance
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Get all verified NGOs
     */
    function getVerifiedNGOs() external view returns (address[] memory) {
        address[] memory activeNGOs = new address[](ngoCount);
        uint256 index = 0;
        
        for (uint256 i = 0; i < ngoList.length; i++) {
            if (verifiedNGOs[ngoList[i]]) {
                activeNGOs[index] = ngoList[i];
                index++;
            }
        }
        
        return activeNGOs;
    }
    
    /**
     * @dev Check if an address is a verified NGO
     */
    function isVerifiedNGO(address _ngoAddress) external view returns (bool) {
        return verifiedNGOs[_ngoAddress];
    }
    
    /**
     * @dev Get donation statistics
     */
    function getDonationStats() external view returns (
        uint256 total,
        uint256 withdrawn,
        uint256 available,
        uint256 ngoTotal
    ) {
        return (
            totalDonations,
            totalWithdrawals,
            address(this).balance,
            ngoCount
        );
    }
    
    /**
     * @dev Get donor's total contributions
     */
    function getDonorContribution(address _donor) external view returns (uint256) {
        return donorContributions[_donor];
    }
    
    /**
     * @dev Get NGO's total withdrawals
     */
    function getNGOWithdrawals(address _ngo) external view returns (uint256) {
        return ngoWithdrawals[_ngo];
    }

    /**
     * @dev Fallback function to receive ETH donations
     */
    receive() external payable {
        if (msg.value > 0) {
            totalDonations += msg.value;
            donorContributions[msg.sender] += msg.value;
            
            emit DonationReceived(
                msg.sender, 
                msg.value, 
                block.timestamp,
                totalDonations
            );
        }
    }
}