'use client';

import { formatAddress, formatBalance, useWallet } from '@/contexts/WalletContext';
import { ethers } from 'ethers';
import {
    AlertTriangle,
    Check,
    DollarSign,
    Eye,
    EyeOff,
    Plus,
    RefreshCw,
    Settings,
    Shield,
    Users,
    X
} from 'lucide-react';
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';

// Contract ABI for admin functions
const ADMIN_ABI = [
    'function owner() view returns (address)',
    'function registerNGO(address ngoAddress)',
    'function revokeNGO(address ngoAddress)',
    'function withdrawFunds(uint256 amount)',
    'function getContractBalance() view returns (uint256)',
    'function getTotalDonations() view returns (uint256)',
    'function isNGOVerified(address ngoAddress) view returns (bool)',
    'function verifiedNGOs(uint256) view returns (address)',
    'function verifiedNGOsCount() view returns (uint256)',
    'function emergencyPause()',
    'function emergencyUnpause()',
    'function paused() view returns (bool)',
    'event NGOVerified(address indexed ngoAddress, uint256 timestamp, uint256 ngoIndex)',
    'event NGORevoked(address indexed ngoAddress, uint256 timestamp)',
    'event FundsWithdrawn(address indexed recipient, uint256 amount, uint256 timestamp, uint256 remainingBalance)'
];

interface NGO {
    address: string;
    isVerified: boolean;
    verifiedAt?: number;
}

interface ContractStats {
    totalDonations: string;
    contractBalance: string;
    totalNGOs: number;
    isPaused: boolean;
}

interface AdminPanelProps {
    className?: string;
}

export default function AdminPanel({ className = '' }: AdminPanelProps) {
    const { provider, signer, account, isConnected } = useWallet();

    const [isOwner, setIsOwner] = useState(false);
    const [loading, setLoading] = useState(true);
    const [stats, setStats] = useState<ContractStats>({
        totalDonations: '0',
        contractBalance: '0',
        totalNGOs: 0,
        isPaused: false
    });

    const [ngos, setNgos] = useState<NGO[]>([]);
    const [newNgoAddress, setNewNgoAddress] = useState('');
    const [withdrawAmount, setWithdrawAmount] = useState('');
    const [showSensitiveData, setShowSensitiveData] = useState(false);
    const [actionLoading, setActionLoading] = useState<string | null>(null);

    // Get contract instance
    const getContract = useCallback(() => {
        const contractAddress = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS;
        if (!contractAddress || !signer) return null;

        return new ethers.Contract(contractAddress, ADMIN_ABI, signer);
    }, [signer]);

    // Check if connected account is the owner
    const checkOwnership = useCallback(async () => {
        if (!account || !provider) return;

        try {
            const contract = getContract();
            if (!contract) return;

            const owner = await contract.owner();
            setIsOwner(owner.toLowerCase() === account.toLowerCase());
        } catch (error) {
            console.error('Failed to check ownership:', error);
            setIsOwner(false);
        }
    }, [account, provider, getContract]);

    // Load contract stats
    const loadStats = useCallback(async () => {
        try {
            const contract = getContract();
            if (!contract) return;

            const [totalDonations, contractBalance, ngoCount, isPaused] = await Promise.all([
                contract.getTotalDonations(),
                contract.getContractBalance(),
                contract.verifiedNGOsCount(),
                contract.paused()
            ]);

            setStats({
                totalDonations: ethers.formatEther(totalDonations),
                contractBalance: ethers.formatEther(contractBalance),
                totalNGOs: Number(ngoCount),
                isPaused
            });
        } catch (error) {
            console.error('Failed to load stats:', error);
            toast.error('Failed to load contract statistics');
        }
    }, [getContract]);

    // Load verified NGOs
    const loadNGOs = useCallback(async () => {
        try {
            const contract = getContract();
            if (!contract) return;

            const ngoCount = await contract.verifiedNGOsCount();
            const ngoList: NGO[] = [];

            for (let i = 0; i < Number(ngoCount); i++) {
                try {
                    const ngoAddress = await contract.verifiedNGOs(i);
                    const isVerified = await contract.isNGOVerified(ngoAddress);

                    ngoList.push({
                        address: ngoAddress,
                        isVerified
                    });
                } catch (error) {
                    console.error(`Failed to load NGO at index ${i}:`, error);
                }
            }

            setNgos(ngoList);
        } catch (error) {
            console.error('Failed to load NGOs:', error);
            toast.error('Failed to load NGO list');
        }
    }, [getContract]);

    // Load all data
    const loadData = useCallback(async () => {
        setLoading(true);
        await Promise.all([
            checkOwnership(),
            loadStats(),
            loadNGOs()
        ]);
        setLoading(false);
    }, [checkOwnership, loadStats, loadNGOs]);

    // Load data on component mount and when dependencies change
    useEffect(() => {
        if (isConnected && provider && signer) {
            loadData();
        }
    }, [isConnected, provider, signer, loadData]);

    // Register NGO
    const registerNGO = async () => {
        if (!newNgoAddress.trim()) {
            toast.error('Please enter a valid NGO address');
            return;
        }

        if (!ethers.isAddress(newNgoAddress)) {
            toast.error('Please enter a valid Ethereum address');
            return;
        }

        try {
            setActionLoading('register');
            const contract = getContract();
            if (!contract) throw new Error('Contract not available');

            const tx = await contract.registerNGO(newNgoAddress);
            toast.loading('Registering NGO...', { id: 'register-ngo' });

            await tx.wait();
            toast.success('NGO registered successfully!', { id: 'register-ngo' });

            setNewNgoAddress('');
            await loadData(); // Refresh data
        } catch (error: any) {
            console.error('Failed to register NGO:', error);
            toast.error(error.message || 'Failed to register NGO', { id: 'register-ngo' });
        } finally {
            setActionLoading(null);
        }
    };

    // Revoke NGO
    const revokeNGO = async (ngoAddress: string) => {
        if (!confirm(`Are you sure you want to revoke verification for ${formatAddress(ngoAddress)}?`)) {
            return;
        }

        try {
            setActionLoading(`revoke-${ngoAddress}`);
            const contract = getContract();
            if (!contract) throw new Error('Contract not available');

            const tx = await contract.revokeNGO(ngoAddress);
            toast.loading('Revoking NGO...', { id: 'revoke-ngo' });

            await tx.wait();
            toast.success('NGO revoked successfully!', { id: 'revoke-ngo' });

            await loadData(); // Refresh data
        } catch (error: any) {
            console.error('Failed to revoke NGO:', error);
            toast.error(error.message || 'Failed to revoke NGO', { id: 'revoke-ngo' });
        } finally {
            setActionLoading(null);
        }
    };

    // Withdraw funds
    const withdrawFunds = async () => {
        if (!withdrawAmount.trim()) {
            toast.error('Please enter withdrawal amount');
            return;
        }

        const amount = parseFloat(withdrawAmount);
        if (isNaN(amount) || amount <= 0) {
            toast.error('Please enter a valid amount');
            return;
        }

        const availableBalance = parseFloat(stats.contractBalance);
        if (amount > availableBalance) {
            toast.error('Insufficient contract balance');
            return;
        }

        if (!confirm(`Are you sure you want to withdraw ${amount} ETH?`)) {
            return;
        }

        try {
            setActionLoading('withdraw');
            const contract = getContract();
            if (!contract) throw new Error('Contract not available');

            const amountWei = ethers.parseEther(withdrawAmount);
            const tx = await contract.withdrawFunds(amountWei);
            toast.loading('Withdrawing funds...', { id: 'withdraw-funds' });

            await tx.wait();
            toast.success('Funds withdrawn successfully!', { id: 'withdraw-funds' });

            setWithdrawAmount('');
            await loadData(); // Refresh data
        } catch (error: any) {
            console.error('Failed to withdraw funds:', error);
            toast.error(error.message || 'Failed to withdraw funds', { id: 'withdraw-funds' });
        } finally {
            setActionLoading(null);
        }
    };

    // Toggle pause state
    const togglePause = async () => {
        const action = stats.isPaused ? 'unpause' : 'pause';

        if (!confirm(`Are you sure you want to ${action} the contract?`)) {
            return;
        }

        try {
            setActionLoading('pause');
            const contract = getContract();
            if (!contract) throw new Error('Contract not available');

            const tx = stats.isPaused
                ? await contract.emergencyUnpause()
                : await contract.emergencyPause();

            toast.loading(`${action === 'pause' ? 'Pausing' : 'Unpausing'} contract...`, { id: 'toggle-pause' });

            await tx.wait();
            toast.success(`Contract ${action}d successfully!`, { id: 'toggle-pause' });

            await loadData(); // Refresh data
        } catch (error: any) {
            console.error(`Failed to ${action} contract:`, error);
            toast.error(error.message || `Failed to ${action} contract`, { id: 'toggle-pause' });
        } finally {
            setActionLoading(null);
        }
    };

    // Not connected or not owner
    if (!isConnected) {
        return (
            <div className={`card ${className}`}>
                <div className="flex items-center justify-center py-12">
                    <div className="text-center">
                        <Shield className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                        <h3 className="text-lg font-medium text-gray-900 mb-2">Admin Panel</h3>
                        <p className="text-gray-600">Please connect your wallet to access admin features</p>
                    </div>
                </div>
            </div>
        );
    }

    if (!isOwner) {
        return (
            <div className={`card ${className}`}>
                <div className="flex items-center justify-center py-12">
                    <div className="text-center">
                        <AlertTriangle className="h-12 w-12 text-red-400 mx-auto mb-4" />
                        <h3 className="text-lg font-medium text-gray-900 mb-2">Access Denied</h3>
                        <p className="text-gray-600">
                            Only the contract owner can access this admin panel
                        </p>
                        <p className="text-sm text-gray-500 mt-2">
                            Connected as: {formatAddress(account || '')}
                        </p>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className={`space-y-6 ${className}`}>
            {/* Header */}
            <div className="card">
                <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3">
                        <div className="w-12 h-12 rounded-full bg-gradient-to-br from-red-500 to-pink-600 flex items-center justify-center">
                            <Shield className="h-6 w-6 text-white" />
                        </div>
                        <div>
                            <h2 className="text-xl font-semibold text-gray-900">Admin Panel</h2>
                            <p className="text-sm text-gray-600">
                                Contract management and oversight
                            </p>
                        </div>
                    </div>

                    <div className="flex items-center gap-2">
                        <button
                            onClick={() => setShowSensitiveData(!showSensitiveData)}
                            className="btn btn-secondary btn-sm"
                            title={showSensitiveData ? 'Hide sensitive data' : 'Show sensitive data'}
                        >
                            {showSensitiveData ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                        </button>

                        <button
                            onClick={loadData}
                            disabled={loading}
                            className="btn btn-secondary btn-sm"
                            title="Refresh data"
                        >
                            <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                        </button>
                    </div>
                </div>

                {/* Contract Status */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div className="bg-blue-50 rounded-lg p-4">
                        <div className="flex items-center gap-2 mb-2">
                            <DollarSign className="h-5 w-5 text-blue-600" />
                            <span className="text-sm font-medium text-blue-800">Total Donations</span>
                        </div>
                        <div className="text-2xl font-bold text-blue-900">
                            {showSensitiveData ? formatBalance(stats.totalDonations) : '****'} ETH
                        </div>
                    </div>

                    <div className="bg-green-50 rounded-lg p-4">
                        <div className="flex items-center gap-2 mb-2">
                            <DollarSign className="h-5 w-5 text-green-600" />
                            <span className="text-sm font-medium text-green-800">Contract Balance</span>
                        </div>
                        <div className="text-2xl font-bold text-green-900">
                            {showSensitiveData ? formatBalance(stats.contractBalance) : '****'} ETH
                        </div>
                    </div>

                    <div className="bg-purple-50 rounded-lg p-4">
                        <div className="flex items-center gap-2 mb-2">
                            <Users className="h-5 w-5 text-purple-600" />
                            <span className="text-sm font-medium text-purple-800">Verified NGOs</span>
                        </div>
                        <div className="text-2xl font-bold text-purple-900">
                            {stats.totalNGOs}
                        </div>
                    </div>

                    <div className={`rounded-lg p-4 ${stats.isPaused ? 'bg-red-50' : 'bg-green-50'}`}>
                        <div className="flex items-center gap-2 mb-2">
                            <Settings className={`h-5 w-5 ${stats.isPaused ? 'text-red-600' : 'text-green-600'}`} />
                            <span className={`text-sm font-medium ${stats.isPaused ? 'text-red-800' : 'text-green-800'}`}>
                                Contract Status
                            </span>
                        </div>
                        <div className={`text-2xl font-bold ${stats.isPaused ? 'text-red-900' : 'text-green-900'}`}>
                            {stats.isPaused ? 'Paused' : 'Active'}
                        </div>
                    </div>
                </div>
            </div>

            {/* NGO Management */}
            <div className="card">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">NGO Management</h3>

                {/* Add New NGO */}
                <div className="mb-6 p-4 bg-gray-50 rounded-lg">
                    <h4 className="text-md font-medium text-gray-800 mb-3">Register New NGO</h4>
                    <div className="flex gap-3">
                        <input
                            type="text"
                            placeholder="NGO Ethereum Address (0x...)"
                            value={newNgoAddress}
                            onChange={(e) => setNewNgoAddress(e.target.value)}
                            className="input flex-1"
                        />
                        <button
                            onClick={registerNGO}
                            disabled={actionLoading === 'register' || !newNgoAddress.trim()}
                            className="btn btn-primary"
                        >
                            {actionLoading === 'register' ? (
                                <RefreshCw className="h-4 w-4 animate-spin" />
                            ) : (
                                <Plus className="h-4 w-4" />
                            )}
                            Register
                        </button>
                    </div>
                </div>

                {/* NGO List */}
                <div className="space-y-3">
                    {ngos.length === 0 ? (
                        <div className="text-center py-8">
                            <Users className="h-8 w-8 text-gray-300 mx-auto mb-2" />
                            <p className="text-gray-600">No NGOs registered yet</p>
                        </div>
                    ) : (
                        ngos.map((ngo) => (
                            <div key={ngo.address} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                <div className="flex items-center gap-3">
                                    <div className={`w-3 h-3 rounded-full ${ngo.isVerified ? 'bg-green-500' : 'bg-red-500'}`} />
                                    <div>
                                        <div className="font-mono text-sm font-medium">
                                            {formatAddress(ngo.address, 8)}
                                        </div>
                                        <div className={`text-xs ${ngo.isVerified ? 'text-green-600' : 'text-red-600'}`}>
                                            {ngo.isVerified ? 'Verified' : 'Revoked'}
                                        </div>
                                    </div>
                                </div>

                                {ngo.isVerified && (
                                    <button
                                        onClick={() => revokeNGO(ngo.address)}
                                        disabled={actionLoading === `revoke-${ngo.address}`}
                                        className="btn btn-sm bg-red-100 text-red-700 hover:bg-red-200"
                                    >
                                        {actionLoading === `revoke-${ngo.address}` ? (
                                            <RefreshCw className="h-3 w-3 animate-spin" />
                                        ) : (
                                            <X className="h-3 w-3" />
                                        )}
                                        Revoke
                                    </button>
                                )}
                            </div>
                        ))
                    )}
                </div>
            </div>

            {/* Financial Management */}
            <div className="card">
                <h3 className="text-lg font-semibold text-gray-900 mb-4">Financial Management</h3>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    {/* Withdraw Funds */}
                    <div className="p-4 bg-blue-50 rounded-lg">
                        <h4 className="text-md font-medium text-blue-800 mb-3">Withdraw Funds</h4>
                        <div className="space-y-3">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">
                                    Amount (ETH)
                                </label>
                                <input
                                    type="number"
                                    step="0.001"
                                    placeholder="0.0"
                                    value={withdrawAmount}
                                    onChange={(e) => setWithdrawAmount(e.target.value)}
                                    className="input w-full"
                                />
                                <p className="text-xs text-gray-600 mt-1">
                                    Available: {formatBalance(stats.contractBalance)} ETH
                                </p>
                            </div>
                            <button
                                onClick={withdrawFunds}
                                disabled={actionLoading === 'withdraw' || !withdrawAmount.trim()}
                                className="btn btn-primary w-full"
                            >
                                {actionLoading === 'withdraw' ? (
                                    <RefreshCw className="h-4 w-4 animate-spin" />
                                ) : (
                                    <DollarSign className="h-4 w-4" />
                                )}
                                Withdraw Funds
                            </button>
                        </div>
                    </div>

                    {/* Emergency Controls */}
                    <div className="p-4 bg-red-50 rounded-lg">
                        <h4 className="text-md font-medium text-red-800 mb-3">Emergency Controls</h4>
                        <div className="space-y-3">
                            <p className="text-sm text-gray-700">
                                Emergency pause will stop all donations and withdrawals until unpaused.
                            </p>
                            <button
                                onClick={togglePause}
                                disabled={actionLoading === 'pause'}
                                className={`btn w-full ${stats.isPaused
                                        ? 'bg-green-600 hover:bg-green-700 text-white'
                                        : 'bg-red-600 hover:bg-red-700 text-white'
                                    }`}
                            >
                                {actionLoading === 'pause' ? (
                                    <RefreshCw className="h-4 w-4 animate-spin" />
                                ) : stats.isPaused ? (
                                    <Check className="h-4 w-4" />
                                ) : (
                                    <AlertTriangle className="h-4 w-4" />
                                )}
                                {stats.isPaused ? 'Unpause Contract' : 'Emergency Pause'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}