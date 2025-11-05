'use client';

import { formatAddress, formatBalance, useWallet } from '@/contexts/WalletContext';
import { format } from 'date-fns';
import { ethers } from 'ethers';
import {
    Calendar,
    Download,
    ExternalLink,
    Filter,
    RefreshCw,
    Search,
    Table
} from 'lucide-react';
import React, { useCallback, useEffect, useState } from 'react';

// Contract ABI for reading events
const CONTRACT_ABI = [
    'event DonationReceived(address indexed donor, uint256 amount, uint256 timestamp, uint256 newTotalDonations)',
    'event FundsWithdrawn(address indexed recipient, uint256 amount, uint256 timestamp, uint256 remainingBalance)',
    'event NGOVerified(address indexed ngoAddress, uint256 timestamp, uint256 ngoIndex)'
];

interface TransactionEvent {
    id: string;
    type: 'donation' | 'withdrawal' | 'verification';
    address: string;
    amount?: string;
    timestamp: number;
    blockNumber: number;
    transactionHash: string;
    remainingBalance?: string;
}

interface TransactionLedgerProps {
    className?: string;
    refreshTrigger?: number;
}

export default function TransactionLedger({ className = '', refreshTrigger }: TransactionLedgerProps) {
    const { provider, isConnected } = useWallet();

    const [transactions, setTransactions] = useState<TransactionEvent[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [filter, setFilter] = useState<'all' | 'donation' | 'withdrawal' | 'verification'>('all');
    const [searchTerm, setSearchTerm] = useState('');
    const [sortBy, setSortBy] = useState<'timestamp' | 'amount' | 'type'>('timestamp');
    const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');

    // Load transaction events from blockchain
    const loadTransactions = useCallback(async () => {
        if (!provider) return;

        const contractAddress = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS;
        if (!contractAddress) {
            setError('Contract address not configured');
            setLoading(false);
            return;
        }

        try {
            setLoading(true);
            setError(null);

            const contract = new ethers.Contract(contractAddress, CONTRACT_ABI, provider);

            // Get current block number
            const currentBlock = await provider.getBlockNumber();
            const fromBlock = Math.max(0, currentBlock - 10000); // Last ~10k blocks (about 2 weeks)

            // Fetch all events in parallel
            const [donationEvents, withdrawalEvents, verificationEvents] = await Promise.all([
                contract.queryFilter('DonationReceived', fromBlock, 'latest'),
                contract.queryFilter('FundsWithdrawn', fromBlock, 'latest'),
                contract.queryFilter('NGOVerified', fromBlock, 'latest')
            ]);

            // Process and combine events
            const allEvents: TransactionEvent[] = [];

            // Process donation events
            donationEvents.forEach((event, index) => {
                if ('args' in event && event.args) {
                    allEvents.push({
                        id: `donation-${event.transactionHash}-${index}`,
                        type: 'donation',
                        address: event.args[0] as string, // donor
                        amount: ethers.formatEther(event.args[1] as bigint), // amount
                        timestamp: Number(event.args[2] as bigint) * 1000, // timestamp (convert to ms)
                        blockNumber: event.blockNumber,
                        transactionHash: event.transactionHash,
                        remainingBalance: ethers.formatEther((event.args[3] as bigint) || BigInt(0)) // newTotalDonations
                    });
                }
            });

            // Process withdrawal events
            withdrawalEvents.forEach((event, index) => {
                if ('args' in event && event.args) {
                    allEvents.push({
                        id: `withdrawal-${event.transactionHash}-${index}`,
                        type: 'withdrawal',
                        address: event.args[0] as string, // recipient
                        amount: ethers.formatEther(event.args[1] as bigint), // amount
                        timestamp: Number(event.args[2] as bigint) * 1000, // timestamp
                        blockNumber: event.blockNumber,
                        transactionHash: event.transactionHash,
                        remainingBalance: ethers.formatEther((event.args[3] as bigint) || BigInt(0)) // remainingBalance
                    });
                }
            });

            // Process verification events
            verificationEvents.forEach((event, index) => {
                if ('args' in event && event.args) {
                    allEvents.push({
                        id: `verification-${event.transactionHash}-${index}`,
                        type: 'verification',
                        address: event.args[0] as string, // ngoAddress
                        timestamp: Number(event.args[1] as bigint) * 1000, // timestamp
                        blockNumber: event.blockNumber,
                        transactionHash: event.transactionHash
                    });
                }
            });

            // Sort by timestamp (newest first by default)
            allEvents.sort((a, b) => b.timestamp - a.timestamp);

            setTransactions(allEvents);
        } catch (err: any) {
            console.error('Failed to load transactions:', err);
            setError(err.message || 'Failed to load transaction history');
        } finally {
            setLoading(false);
        }
    }, [provider]);

    // Load transactions on mount and when provider changes
    useEffect(() => {
        loadTransactions();
    }, [loadTransactions]);

    // Refresh when refreshTrigger changes
    useEffect(() => {
        if (refreshTrigger) {
            loadTransactions();
        }
    }, [refreshTrigger, loadTransactions]);

    // Filter and sort transactions
    const filteredAndSortedTransactions = React.useMemo(() => {
        let filtered = transactions;

        // Apply filter
        if (filter !== 'all') {
            filtered = filtered.filter(tx => tx.type === filter);
        }

        // Apply search
        if (searchTerm) {
            const term = searchTerm.toLowerCase();
            filtered = filtered.filter(tx =>
                tx.address.toLowerCase().includes(term) ||
                tx.transactionHash.toLowerCase().includes(term) ||
                tx.type.toLowerCase().includes(term) ||
                (tx.amount && tx.amount.includes(term))
            );
        }

        // Apply sorting
        filtered.sort((a, b) => {
            let comparison = 0;

            switch (sortBy) {
                case 'timestamp':
                    comparison = a.timestamp - b.timestamp;
                    break;
                case 'amount':
                    const amountA = parseFloat(a.amount || '0');
                    const amountB = parseFloat(b.amount || '0');
                    comparison = amountA - amountB;
                    break;
                case 'type':
                    comparison = a.type.localeCompare(b.type);
                    break;
            }

            return sortOrder === 'asc' ? comparison : -comparison;
        });

        return filtered;
    }, [transactions, filter, searchTerm, sortBy, sortOrder]);

    // Get transaction type icon and color
    const getTransactionTypeInfo = (type: string) => {
        switch (type) {
            case 'donation':
                return {
                    icon: '💝',
                    color: 'text-charity-600 bg-charity-50',
                    label: 'Donation'
                };
            case 'withdrawal':
                return {
                    icon: '💰',
                    color: 'text-blue-600 bg-blue-50',
                    label: 'Withdrawal'
                };
            case 'verification':
                return {
                    icon: '✅',
                    color: 'text-green-600 bg-green-50',
                    label: 'NGO Verified'
                };
            default:
                return {
                    icon: '📄',
                    color: 'text-gray-600 bg-gray-50',
                    label: 'Unknown'
                };
        }
    };

    // Export to CSV
    const exportToCSV = () => {
        const csvContent = [
            ['Type', 'Address', 'Amount (ETH)', 'Date', 'Transaction Hash'],
            ...filteredAndSortedTransactions.map(tx => [
                tx.type,
                tx.address,
                tx.amount || 'N/A',
                format(new Date(tx.timestamp), 'yyyy-MM-dd HH:mm:ss'),
                tx.transactionHash
            ])
        ].map(row => row.join(',')).join('\n');

        const blob = new Blob([csvContent], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `elysian-charity-transactions-${format(new Date(), 'yyyy-MM-dd')}.csv`;
        a.click();
        URL.revokeObjectURL(url);
    };

    return (
        <div className={`card ${className}`}>
            {/* Header */}
            <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center">
                        <Table className="h-6 w-6 text-white" />
                    </div>
                    <div>
                        <h3 className="text-xl font-semibold text-gray-900">Transaction Ledger</h3>
                        <p className="text-sm text-gray-600">
                            {transactions.length} transactions • Real-time blockchain data
                        </p>
                    </div>
                </div>

                <div className="flex items-center gap-2">
                    <button
                        onClick={loadTransactions}
                        disabled={loading}
                        className="btn btn-secondary btn-sm"
                        title="Refresh transactions"
                    >
                        <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                    </button>

                    <button
                        onClick={exportToCSV}
                        disabled={filteredAndSortedTransactions.length === 0}
                        className="btn btn-secondary btn-sm"
                        title="Export to CSV"
                    >
                        <Download className="h-4 w-4" />
                    </button>
                </div>
            </div>

            {/* Filters and Search */}
            <div className="flex flex-col sm:flex-row gap-4 mb-6">
                {/* Search */}
                <div className="flex-1">
                    <div className="relative">
                        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                        <input
                            type="text"
                            placeholder="Search by address, hash, or type..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            className="input pl-10"
                        />
                    </div>
                </div>

                {/* Filter */}
                <div className="flex items-center gap-2">
                    <Filter className="h-4 w-4 text-gray-400" />
                    <select
                        value={filter}
                        onChange={(e) => setFilter(e.target.value as any)}
                        className="input min-w-[120px]"
                    >
                        <option value="all">All Types</option>
                        <option value="donation">Donations</option>
                        <option value="withdrawal">Withdrawals</option>
                        <option value="verification">Verifications</option>
                    </select>
                </div>

                {/* Sort */}
                <div className="flex items-center gap-2">
                    <Calendar className="h-4 w-4 text-gray-400" />
                    <select
                        value={`${sortBy}-${sortOrder}`}
                        onChange={(e) => {
                            const [field, order] = e.target.value.split('-');
                            setSortBy(field as any);
                            setSortOrder(order as any);
                        }}
                        className="input min-w-[140px]"
                    >
                        <option value="timestamp-desc">Newest First</option>
                        <option value="timestamp-asc">Oldest First</option>
                        <option value="amount-desc">Highest Amount</option>
                        <option value="amount-asc">Lowest Amount</option>
                        <option value="type-asc">Type A-Z</option>
                    </select>
                </div>
            </div>

            {/* Loading State */}
            {loading && (
                <div className="flex items-center justify-center py-12">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
                    <span className="ml-3 text-gray-600">Loading transactions...</span>
                </div>
            )}

            {/* Error State */}
            {error && (
                <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
                    <p className="text-red-800">{error}</p>
                    <button
                        onClick={loadTransactions}
                        className="btn btn-sm bg-red-100 text-red-700 hover:bg-red-200 mt-2"
                    >
                        Retry
                    </button>
                </div>
            )}

            {/* Empty State */}
            {!loading && !error && filteredAndSortedTransactions.length === 0 && (
                <div className="text-center py-12">
                    <Table className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                    <h4 className="text-lg font-medium text-gray-900 mb-2">No transactions found</h4>
                    <p className="text-gray-600">
                        {searchTerm || filter !== 'all'
                            ? 'Try adjusting your search or filter criteria'
                            : 'Transactions will appear here once donations are made'
                        }
                    </p>
                </div>
            )}

            {/* Transaction Table */}
            {!loading && !error && filteredAndSortedTransactions.length > 0 && (
                <div className="overflow-x-auto">
                    <table className="w-full">
                        <thead>
                            <tr className="border-b border-gray-200">
                                <th className="text-left py-3 px-2 font-medium text-gray-700">Type</th>
                                <th className="text-left py-3 px-2 font-medium text-gray-700">Address</th>
                                <th className="text-left py-3 px-2 font-medium text-gray-700">Amount</th>
                                <th className="text-left py-3 px-2 font-medium text-gray-700">Date</th>
                                <th className="text-left py-3 px-2 font-medium text-gray-700">Transaction</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredAndSortedTransactions.map((tx) => {
                                const typeInfo = getTransactionTypeInfo(tx.type);
                                return (
                                    <tr key={tx.id} className="border-b border-gray-100 hover:bg-gray-50">
                                        {/* Type */}
                                        <td className="py-4 px-2">
                                            <div className="flex items-center gap-2">
                                                <span
                                                    className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${typeInfo.color}`}
                                                >
                                                    <span className="mr-1">{typeInfo.icon}</span>
                                                    {typeInfo.label}
                                                </span>
                                            </div>
                                        </td>

                                        {/* Address */}
                                        <td className="py-4 px-2">
                                            <div className="font-mono text-sm">
                                                {formatAddress(tx.address, 6)}
                                            </div>
                                        </td>

                                        {/* Amount */}
                                        <td className="py-4 px-2">
                                            {tx.amount ? (
                                                <div className="flex items-center gap-1">
                                                    <span className="font-medium">
                                                        {formatBalance(tx.amount)}
                                                    </span>
                                                    <span className="text-gray-500 text-sm">ETH</span>
                                                </div>
                                            ) : (
                                                <span className="text-gray-400">—</span>
                                            )}
                                        </td>

                                        {/* Date */}
                                        <td className="py-4 px-2">
                                            <div className="text-sm">
                                                <div className="font-medium">
                                                    {format(new Date(tx.timestamp), 'MMM dd, yyyy')}
                                                </div>
                                                <div className="text-gray-500">
                                                    {format(new Date(tx.timestamp), 'HH:mm:ss')}
                                                </div>
                                            </div>
                                        </td>

                                        {/* Transaction Hash */}
                                        <td className="py-4 px-2">
                                            <a
                                                href={`https://sepolia.etherscan.io/tx/${tx.transactionHash}`}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="flex items-center gap-1 text-primary-600 hover:text-primary-800 transition-colors"
                                            >
                                                <span className="font-mono text-sm">
                                                    {formatAddress(tx.transactionHash, 6)}
                                                </span>
                                                <ExternalLink className="h-3 w-3" />
                                            </a>
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                </div>
            )}

            {/* Statistics Footer */}
            {!loading && !error && transactions.length > 0 && (
                <div className="mt-6 pt-6 border-t border-gray-200">
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                        <div className="text-center">
                            <div className="text-2xl font-bold text-charity-600">
                                {transactions.filter(tx => tx.type === 'donation').length}
                            </div>
                            <div className="text-sm text-gray-600">Total Donations</div>
                        </div>

                        <div className="text-center">
                            <div className="text-2xl font-bold text-blue-600">
                                {transactions.filter(tx => tx.type === 'withdrawal').length}
                            </div>
                            <div className="text-sm text-gray-600">Withdrawals</div>
                        </div>

                        <div className="text-center">
                            <div className="text-2xl font-bold text-green-600">
                                {transactions.filter(tx => tx.type === 'verification').length}
                            </div>
                            <div className="text-sm text-gray-600">Verified NGOs</div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}