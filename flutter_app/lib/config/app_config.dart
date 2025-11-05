class AppConfig {
  // Network Configuration - Sepolia Testnet
  static const String rpcUrl = 'https://sepolia.infura.io/v3/YOUR_INFURA_ID';
  static const int chainId = 11155111;
  static const String networkName = 'Sepolia Testnet';
  
  // Contract Address (Update after deployment)
  static const String contractAddress = '0x0000000000000000000000000000000000000000';
  
  // Block Explorer
  static const String blockExplorerUrl = 'https://sepolia.etherscan.io';
  
  // Features Toggle
  static const bool enableRealWallet = true; // MetaMask integration
  static const bool enableRealBalance = true; // Real blockchain balance
  static const bool enableRealDonations = true; // Real transactions
  static const bool useMockTransactions = true; // Mock transaction history
  
  // UI Configuration
  static const int pollingInterval = 10; // seconds
  static const int maxTransactionsDisplay = 10;
  
  // Contract ABI (Add full ABI after deployment)
  static const String contractABI = '''
  [
    {
      "inputs": [],
      "name": "donate",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        }
      ],
      "name": "withdraw",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getContractBalance",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "totalDonations",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "donor",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "amount",
          "type": "uint256"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "timestamp",
          "type": "uint256"
        }
      ],
      "name": "DonationReceived",
      "type": "event"
    }
  ]
  ''';
  
  // Helper methods
  static String getExplorerUrl(String txHash) {
    return '$blockExplorerUrl/tx/$txHash';
  }
  
  static String getAddressUrl(String address) {
    return '$blockExplorerUrl/address/$address';
  }
}