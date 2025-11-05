// Global type declarations for the project

declare global {
    interface Window {
        ethereum?: {
            isMetaMask?: boolean;
            request: (args: { method: string; params?: any[] }) => Promise<any>;
            on: (event: string, handler: (...args: any[]) => void) => void;
            removeListener: (event: string, handler: (...args: any[]) => void) => void;
            selectedAddress?: string;
            chainId?: string;
        };
    }
}

export interface ContractConfig {
    address: string;
    abi: any[];
}

export interface NetworkConfig {
    chainId: number;
    name: string;
    rpcUrl: string;
    blockExplorer: string;
    currency: {
        name: string;
        symbol: string;
        decimals: number;
    };
}

export interface DonationEvent {
    id: string;
    donor: string;
    amount: string;
    timestamp: number;
    transactionHash: string;
    blockNumber: number;
}

export interface WithdrawalEvent {
    id: string;
    recipient: string;
    amount: string;
    timestamp: number;
    transactionHash: string;
    blockNumber: number;
    remainingBalance: string;
}

export interface NGOVerificationEvent {
    id: string;
    ngoAddress: string;
    timestamp: number;
    transactionHash: string;
    blockNumber: number;
    ngoIndex: number;
}

export interface ContractStats {
    totalDonations: string;
    totalWithdrawals: string;
    availableBalance: string;
    ngoCount: number;
}

export interface NGOInfo {
    address: string;
    isVerified: boolean;
    totalWithdrawals: string;
    registrationDate?: number;
}

export interface TransactionStatus {
    status: 'pending' | 'success' | 'error';
    hash?: string;
    error?: string;
}

export interface FormattedTransaction {
    hash: string;
    type: 'donation' | 'withdrawal' | 'ngo_verification';
    from: string;
    to: string;
    amount?: string;
    timestamp: number;
    blockNumber: number;
    status: 'success' | 'pending' | 'failed';
    etherscanUrl: string;
}

export { };
