'use client';

import { ethers } from 'ethers';
import React, { createContext, useCallback, useContext, useEffect, useState } from 'react';
import toast from 'react-hot-toast';

// Types
interface WalletContextType {
    // Connection state
    isConnected: boolean;
    isConnecting: boolean;
    account: string | null;
    provider: ethers.BrowserProvider | null;
    signer: ethers.JsonRpcSigner | null;

    // Network info
    chainId: number | null;
    networkName: string | null;
    isCorrectNetwork: boolean;

    // Actions
    connect: () => Promise<void>;
    disconnect: () => void;
    switchNetwork: () => Promise<void>;
}

interface WalletProviderProps {
    children: React.ReactNode;
}

// Constants
const SUPPORTED_NETWORKS = {
    sepolia: {
        chainId: 11155111,
        name: 'Sepolia Testnet',
        rpcUrl: 'https://sepolia.infura.io/v3/',
        blockExplorer: 'https://sepolia.etherscan.io',
    },
    goerli: {
        chainId: 5,
        name: 'Goerli Testnet',
        rpcUrl: 'https://goerli.infura.io/v3/',
        blockExplorer: 'https://goerli.etherscan.io',
    },
    localhost: {
        chainId: 31337,
        name: 'Localhost',
        rpcUrl: 'http://127.0.0.1:8545',
        blockExplorer: 'http://localhost:8545',
    }
};

const TARGET_NETWORK = process.env.NEXT_PUBLIC_NETWORK_NAME || 'sepolia';
const TARGET_CHAIN_ID = SUPPORTED_NETWORKS[TARGET_NETWORK as keyof typeof SUPPORTED_NETWORKS]?.chainId || 11155111;

// Context
const WalletContext = createContext<WalletContextType | undefined>(undefined);

// Custom hook
export function useWallet() {
    const context = useContext(WalletContext);
    if (context === undefined) {
        throw new Error('useWallet must be used within a WalletProvider');
    }
    return context;
}

// Provider component
export function WalletProvider({ children }: WalletProviderProps) {
    const [isConnected, setIsConnected] = useState(false);
    const [isConnecting, setIsConnecting] = useState(false);
    const [account, setAccount] = useState<string | null>(null);
    const [provider, setProvider] = useState<ethers.BrowserProvider | null>(null);
    const [signer, setSigner] = useState<ethers.JsonRpcSigner | null>(null);
    const [chainId, setChainId] = useState<number | null>(null);
    const [networkName, setNetworkName] = useState<string | null>(null);

    // Derived state
    const isCorrectNetwork = chainId === TARGET_CHAIN_ID;

    // Check if MetaMask is installed
    const isMetaMaskInstalled = useCallback(() => {
        return typeof window !== 'undefined' && typeof window.ethereum !== 'undefined';
    }, []);

    // Get network name from chain ID
    const getNetworkName = useCallback((chainId: number): string => {
        const network = Object.values(SUPPORTED_NETWORKS).find(n => n.chainId === chainId);
        return network?.name || `Chain ${chainId}`;
    }, []);

    // Initialize provider and check connection
    const initializeProvider = useCallback(async () => {
        if (!isMetaMaskInstalled()) return;

        try {
            const provider = new ethers.BrowserProvider(window.ethereum as any);
            setProvider(provider);

            // Check if already connected
            const accounts = await provider.listAccounts();
            if (accounts.length > 0) {
                const signer = await provider.getSigner();
                const network = await provider.getNetwork();

                setAccount(accounts[0].address);
                setSigner(signer);
                setChainId(Number(network.chainId));
                setNetworkName(getNetworkName(Number(network.chainId)));
                setIsConnected(true);
            }
        } catch (error) {
            console.error('Failed to initialize provider:', error);
        }
    }, [isMetaMaskInstalled, getNetworkName]);

    // Connect wallet
    const connect = useCallback(async () => {
        if (!isMetaMaskInstalled()) {
            toast.error('MetaMask is not installed. Please install MetaMask to continue.');
            window.open('https://metamask.io/download/', '_blank');
            return;
        }

        setIsConnecting(true);

        try {
            const provider = new ethers.BrowserProvider(window.ethereum as any);

            // Request account access
            await provider.send('eth_requestAccounts', []);

            const signer = await provider.getSigner();
            const address = await signer.getAddress();
            const network = await provider.getNetwork();

            setProvider(provider);
            setSigner(signer);
            setAccount(address);
            setChainId(Number(network.chainId));
            setNetworkName(getNetworkName(Number(network.chainId)));
            setIsConnected(true);

            toast.success('Wallet connected successfully!');

            // Check if on correct network
            if (Number(network.chainId) !== TARGET_CHAIN_ID) {
                toast.error(`Please switch to ${SUPPORTED_NETWORKS[TARGET_NETWORK as keyof typeof SUPPORTED_NETWORKS].name}`);
            }

        } catch (error: any) {
            console.error('Failed to connect wallet:', error);

            if (error.code === 4001) {
                toast.error('Connection rejected by user');
            } else {
                toast.error('Failed to connect wallet');
            }
        } finally {
            setIsConnecting(false);
        }
    }, [isMetaMaskInstalled, getNetworkName]);

    // Disconnect wallet
    const disconnect = useCallback(() => {
        setIsConnected(false);
        setAccount(null);
        setProvider(null);
        setSigner(null);
        setChainId(null);
        setNetworkName(null);
        toast.success('Wallet disconnected');
    }, []);

    // Switch to correct network
    const switchNetwork = useCallback(async () => {
        if (!provider) return;

        const targetNetwork = SUPPORTED_NETWORKS[TARGET_NETWORK as keyof typeof SUPPORTED_NETWORKS];

        try {
            await provider.send('wallet_switchEthereumChain', [
                { chainId: `0x${targetNetwork.chainId.toString(16)}` }
            ]);
        } catch (error: any) {
            // This error code indicates that the chain has not been added to MetaMask
            if (error.code === 4902) {
                try {
                    await provider.send('wallet_addEthereumChain', [
                        {
                            chainId: `0x${targetNetwork.chainId.toString(16)}`,
                            chainName: targetNetwork.name,
                            rpcUrls: [targetNetwork.rpcUrl],
                            blockExplorerUrls: [targetNetwork.blockExplorer],
                        }
                    ]);
                } catch (addError) {
                    console.error('Failed to add network:', addError);
                    toast.error('Failed to add network to MetaMask');
                }
            } else {
                console.error('Failed to switch network:', error);
                toast.error('Failed to switch network');
            }
        }
    }, [provider]);

    // Handle account changes
    useEffect(() => {
        if (!isMetaMaskInstalled()) return;

        const handleAccountsChanged = (accounts: string[]) => {
            if (accounts.length === 0) {
                disconnect();
            } else if (account !== accounts[0]) {
                setAccount(accounts[0]);
                toast.success('Account changed');
            }
        };

        const handleChainChanged = (chainId: string) => {
            const newChainId = parseInt(chainId, 16);
            setChainId(newChainId);
            setNetworkName(getNetworkName(newChainId));

            if (newChainId === TARGET_CHAIN_ID) {
                toast.success('Switched to correct network!');
            } else {
                toast.error(`Please switch to ${SUPPORTED_NETWORKS[TARGET_NETWORK as keyof typeof SUPPORTED_NETWORKS].name}`);
            }
        };

        const handleDisconnect = () => {
            disconnect();
        };

        window.ethereum?.on('accountsChanged', handleAccountsChanged);
        window.ethereum?.on('chainChanged', handleChainChanged);
        window.ethereum?.on('disconnect', handleDisconnect);

        return () => {
            window.ethereum?.removeListener('accountsChanged', handleAccountsChanged);
            window.ethereum?.removeListener('chainChanged', handleChainChanged);
            window.ethereum?.removeListener('disconnect', handleDisconnect);
        };
    }, [account, disconnect, getNetworkName, isMetaMaskInstalled]);

    // Initialize on mount
    useEffect(() => {
        initializeProvider();
    }, [initializeProvider]);

    const value: WalletContextType = {
        isConnected,
        isConnecting,
        account,
        provider,
        signer,
        chainId,
        networkName,
        isCorrectNetwork,
        connect,
        disconnect,
        switchNetwork,
    };

    return (
        <WalletContext.Provider value={value}>
            {children}
        </WalletContext.Provider>
    );
}

// Utility function to format address
export function formatAddress(address: string, chars = 4): string {
    if (!address) return '';
    return `${address.slice(0, chars + 2)}...${address.slice(-chars)}`;
}

// Utility function to format balance
export function formatBalance(balance: string | number, decimals = 4): string {
    const num = typeof balance === 'string' ? parseFloat(balance) : balance;
    if (isNaN(num)) return '0';

    if (num < 0.0001) return '< 0.0001';
    if (num >= 1000) return num.toLocaleString(undefined, { maximumFractionDigits: 2 });

    return num.toFixed(decimals);
}