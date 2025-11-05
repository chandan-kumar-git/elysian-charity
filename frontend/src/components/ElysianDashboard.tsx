'use client';

import { formatAddress, useWallet } from '@/contexts/WalletContext';
import { formatDistanceToNow } from 'date-fns';
import {
    AlertCircle,
    DollarSign,
    ExternalLink,
    Eye,
    Settings,
    TrendingUp,
    X,
} from 'lucide-react';
import React, { useEffect, useMemo, useState } from 'react';
import AdminPanel from './AdminPanel';
import DonationForm from './DonationForm';
import MetaMaskInstallPrompt from './MetaMaskInstallPrompt';
import TransactionLedger from './TransactionLedger';
import WalletConnector from './WalletConnector';

interface Transaction {
    id: string;
    type: 'donation' | 'withdrawal';
    address: string;
    amount: string;
    timestamp: number;
    txHash: string;
}

const FALLBACK_CONTRACT_OWNER = '0x742d35Cc6634C0532925a3b8D093b3F2bFC2c5b9';
const FALLBACK_CONTRACT_ADDRESS = '0xYourContractAddress';
const FALLBACK_EXPLORER = 'https://sepolia.etherscan.io';

const OWNER_ADDRESS = (process.env.NEXT_PUBLIC_OWNER_ADDRESS || FALLBACK_CONTRACT_OWNER).toLowerCase();
const CONTRACT_ADDRESS = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS || FALLBACK_CONTRACT_ADDRESS;
const EXPLORER_BASE = process.env.NEXT_PUBLIC_BLOCK_EXPLORER || FALLBACK_EXPLORER;

const INITIAL_TRANSACTIONS: Transaction[] = [
    {
        id: '1',
        type: 'donation',
        address: '0x742d35Cc6634C0532925a3b8D093b3F2bFC2c5b9',
        amount: '5.20',
        timestamp: Date.now() - 3600000,
        txHash: '0xabcd...1234',
    },
    {
        id: '2',
        type: 'donation',
        address: '0x8ba1f109551bD432803012645Hac136c39C40',
        amount: '2.25',
        timestamp: Date.now() - 7200000,
        txHash: '0xefgh...5678',
    },
    {
        id: '3',
        type: 'withdrawal',
        address: '0x123d35Cc6634C0532925a3b8D093b3F2bFC2987',
        amount: '1.40',
        timestamp: Date.now() - 10800000,
        txHash: '0xijkl...9012',
    },
    {
        id: '4',
        type: 'donation',
        address: '0x9f8b64dd61d0396f79e54c9a2de68132b1f4f671',
        amount: '3.80',
        timestamp: Date.now() - 14400000,
        txHash: '0xmnop...3456',
    },
];

const formatFiatEstimate = (ethAmount: string) => {
    const parsed = Number.parseFloat(ethAmount);
    if (!Number.isFinite(parsed)) {
        return '$0.00';
    }
    const usdValue = parsed * 2500;
    return `$${usdValue.toLocaleString(undefined, {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    })}`;
};

const ElysianDashboard: React.FC = () => {
    const { isConnected, account } = useWallet();

    const [hasMetaMask, setHasMetaMask] = useState(true);
    const [contractBalance, setContractBalance] = useState('25.567');
    const [totalDonationsLifetime, setTotalDonationsLifetime] = useState('142.340');
    const [transactions, setTransactions] = useState<Transaction[]>(() => [...INITIAL_TRANSACTIONS]);
    const [showDonationForm, setShowDonationForm] = useState(false);
    const [showAdminPanel, setShowAdminPanel] = useState(false);
    const [showLedgerModal, setShowLedgerModal] = useState(false);
    const [showMetaMaskPrompt, setShowMetaMaskPrompt] = useState(false);
    const [ledgerRefreshToken, setLedgerRefreshToken] = useState(() => Date.now());

    const cycleDelta = '+12.5%';

    useEffect(() => {
        const ethereum = typeof window !== 'undefined' ? (window as any).ethereum : undefined;
        const available = Boolean(ethereum);
        setHasMetaMask(available);
        if (!available) {
            setShowMetaMaskPrompt(true);
        }
    }, []);

    const isAdmin = isConnected && account ? account.toLowerCase() === OWNER_ADDRESS : false;

    const ledgerPreview = useMemo(() => transactions.slice(0, 3), [transactions]);

    const handleDonationSuccess = (amount: string, txHash: string) => {
        const numericAmount = Number.parseFloat(amount);
        const sanitizedAmount = Number.isFinite(numericAmount) ? numericAmount.toFixed(2) : amount;

        if (Number.isFinite(numericAmount)) {
            setContractBalance((prev) => {
                const previousValue = Number.parseFloat(prev) || 0;
                return (previousValue + numericAmount).toFixed(3);
            });

            setTotalDonationsLifetime((prev) => {
                const previousValue = Number.parseFloat(prev) || 0;
                return (previousValue + numericAmount).toFixed(3);
            });
        }

        setTransactions((prev) => [
            {
                id: `donation-${Date.now()}`,
                type: 'donation',
                address: account ?? '0x0000000000000000000000000000000000000000',
                amount: sanitizedAmount,
                timestamp: Date.now(),
                txHash,
            },
            ...prev,
        ]);

        setLedgerRefreshToken(Date.now());
        setShowDonationForm(false);
    };

    const promptDonation = () => {
        const ethereum = typeof window !== 'undefined' ? (window as any).ethereum : undefined;
        if (!ethereum) {
            setHasMetaMask(false);
            setShowMetaMaskPrompt(true);
            return;
        }
        setShowDonationForm(true);
    };

    const openExplorer = () => {
        if (typeof window === 'undefined') {
            return;
        }
        window.open(`${EXPLORER_BASE}/address/${CONTRACT_ADDRESS}`, '_blank');
    };

    const explorerLabel = useMemo(() => {
        const explorerUrl = new URL(EXPLORER_BASE);
        return explorerUrl.hostname.replace('www.', '');
    }, []);

    const balanceDisplay = Number.parseFloat(contractBalance) || 0;
    const lifetimeDisplay = Number.parseFloat(totalDonationsLifetime) || 0;

    return (
        <div className="relative min-h-screen overflow-hidden bg-gradient-to-br from-[#050816] via-[#0b0f2b] to-[#101747] py-16">
            <div className="pointer-events-none absolute -top-32 left-1/2 h-64 w-64 -translate-x-1/2 rounded-full bg-blue-500/30 blur-3xl" />
            <div className="pointer-events-none absolute bottom-0 right-12 h-64 w-64 rounded-full bg-green-400/25 blur-3xl" />

            <div className="relative mx-auto flex w-full max-w-[380px] justify-center px-4">
                <div className="relative w-full rounded-[38px] border border-white/10 bg-gradient-to-br from-[#17243f] via-[#111b33] to-[#0b1329] shadow-[0_30px_80px_rgba(0,0,0,0.55)]">
                    <div className="absolute left-1/2 top-4 h-7 w-32 -translate-x-1/2 rounded-full bg-black/80" />

                    <div className="flex items-center justify-between px-7 pt-8 text-[11px] text-gray-400">
                        <span>Elysian Chain</span>
                        <span className="tracking-[0.3em] text-gray-500">EVM</span>
                        <span>UTC • Live</span>
                    </div>

                    <div className="px-7 pb-10 pt-6">
                        <div className="mb-8 flex items-start justify-between">
                            <div>
                                <p className="text-[11px] uppercase tracking-[0.32em] text-blue-200/60">Elysian Transparency</p>
                                <h1 className="mt-1 text-[28px] font-semibold text-white">Contract Health</h1>
                            </div>
                            <div className="flex items-center space-x-3">
                                <WalletConnector className="origin-top-right scale-75" />
                                <button
                                    aria-label="Open steward controls"
                                    className={`rounded-full border border-white/10 p-2 backdrop-blur-sm transition ${isAdmin ? 'text-white' : 'cursor-not-allowed text-white/30'
                                        }`}
                                    disabled={!isAdmin}
                                    onClick={() => setShowAdminPanel(true)}
                                >
                                    <Settings className="h-5 w-5" />
                                </button>
                            </div>
                        </div>

                        {!hasMetaMask && (
                            <div className="mb-6 flex items-center justify-between rounded-3xl border border-orange-400/30 bg-orange-500/15 px-4 py-3">
                                <div className="flex items-center space-x-3">
                                    <div className="flex h-10 w-10 items-center justify-center rounded-2xl bg-orange-500/25">
                                        <AlertCircle className="h-5 w-5 text-orange-200" />
                                    </div>
                                    <div>
                                        <p className="text-sm font-semibold text-white">MetaMask Required</p>
                                        <p className="text-xs text-orange-100/80">Install to contribute donations securely.</p>
                                    </div>
                                </div>
                                <button
                                    className="text-xs font-medium text-orange-100 hover:text-white"
                                    onClick={() => setShowMetaMaskPrompt(true)}
                                >
                                    Install
                                </button>
                            </div>
                        )}

                        {/* Enhanced Strategy Card - Multi-Template Fusion */}
                        <section className="relative mb-6 overflow-hidden rounded-3xl border border-purple-500/20 bg-gradient-to-br from-[#7c3aed] via-[#6d28d9] to-[#5b21b6] p-6 shadow-[0_25px_60px_rgba(124,58,237,0.45)]">
                            {/* Ambient Glows - FluxChain Style */}
                            <div className="absolute -top-16 right-0 h-32 w-32 rounded-full bg-fuchsia-400/30 blur-3xl animate-pulse" />
                            <div className="absolute bottom-0 left-0 h-32 w-32 rounded-full bg-violet-400/25 blur-3xl animate-pulse" />
                            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 h-40 w-40 rounded-full bg-amber-400/20 blur-3xl" />

                            {/* 3D Coin Animation - ProfitPilot Style */}
                            <div className="absolute -right-8 top-12 opacity-20">
                                <div className="relative h-24 w-24 animate-float">
                                    <div className="absolute inset-0 rounded-full bg-gradient-to-br from-amber-300 via-amber-400 to-amber-600 shadow-[0_20px_50px_rgba(251,191,36,0.6)]" />
                                    <div className="absolute inset-2 rounded-full bg-gradient-to-br from-amber-200 to-amber-500 flex items-center justify-center">
                                        <DollarSign className="h-10 w-10 text-amber-900" />
                                    </div>
                                </div>
                            </div>

                            {/* Risk Badge - DeFi Style */}
                            <div className="absolute right-4 top-4 z-10 flex items-center gap-2 rounded-full border border-green-400/30 bg-green-500/20 px-3 py-1 backdrop-blur-md shadow-[0_8px_25px_rgba(34,197,94,0.3)]">
                                <div className="h-2 w-2 rounded-full bg-green-400 animate-pulse shadow-[0_0_10px_rgba(34,197,94,0.8)]" />
                                <span className="text-[10px] font-semibold text-green-300 uppercase tracking-wider">Verified</span>
                            </div>

                            <div className="mb-6 flex items-start justify-between">
                                <div className="relative z-10">
                                    <div className="flex items-center gap-2 mb-2">
                                        {/* Golden Icon - ProfitPilot Style */}
                                        <div className="relative flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br from-amber-300 via-amber-400 to-amber-600 shadow-[0_12px_35px_rgba(251,191,36,0.5)] animate-pulse-slow">
                                            <div className="absolute inset-0 rounded-2xl bg-gradient-to-br from-amber-200/50 to-transparent" />
                                            <DollarSign className="relative h-7 w-7 text-amber-900 drop-shadow-lg" />
                                        </div>
                                        <div>
                                            <p className="text-[10px] uppercase tracking-[0.32em] text-purple-200/80 font-semibold">Contract TVL</p>
                                            <div className="flex items-center gap-2">
                                                <span className="text-[11px] font-bold text-emerald-300">APY 5.68%</span>
                                                <span className="text-[10px] text-purple-200/60">+</span>
                                                <span className="text-[11px] font-bold text-fuchsia-300">39% SUMRA</span>
                                            </div>
                                        </div>
                                    </div>
                                    {/* Enhanced Balance Display */}
                                    <h2 className="mt-3 bg-gradient-to-r from-white via-amber-100 to-fuchsia-200 bg-clip-text text-[48px] font-bold leading-none text-transparent drop-shadow-[0_0_50px_rgba(255,255,255,0.4)] animate-shimmer">
                                        {balanceDisplay.toLocaleString(undefined, {
                                            minimumFractionDigits: 3,
                                            maximumFractionDigits: 3,
                                        })}{' '}
                                        <span className="text-[38px]">ETH</span>
                                    </h2>
                                    <p className="mt-2 text-sm font-medium text-purple-100/90 flex items-center gap-2">
                                        <span className="inline-block h-2 w-2 rounded-full bg-emerald-400 animate-pulse" />
                                        Total assets • {formatFiatEstimate(contractBalance)}
                                    </p>
                                </div>
                            </div>

                            {/* Glassmorphism Cards - FluxChain Style */}
                            <div className="relative mb-5 overflow-hidden rounded-2xl border border-white/20 bg-gradient-to-br from-white/15 to-white/5 backdrop-blur-xl p-4 shadow-[0_8px_32px_rgba(0,0,0,0.2)]">
                                <div className="absolute inset-0 bg-gradient-to-br from-fuchsia-500/10 to-transparent" />
                                <div className="relative flex items-center justify-between">
                                    <div>
                                        <p className="text-[10px] text-purple-100/80 uppercase tracking-wider font-semibold">Strategy</p>
                                        <p className="text-sm font-bold text-white mt-1 flex items-center gap-2">
                                            <span className="inline-block h-2 w-2 rounded-full bg-cyan-400 animate-pulse" />
                                            Optimized lending yield
                                        </p>
                                    </div>
                                    <div className="text-right">
                                        <p className="text-[10px] text-purple-100/80 uppercase tracking-wider font-semibold">24h Change</p>
                                        <div className="flex items-center gap-1 mt-1">
                                            <TrendingUp className="h-4 w-4 text-emerald-400" />
                                            <p className="text-lg font-bold bg-gradient-to-r from-emerald-300 to-green-400 bg-clip-text text-transparent">
                                                {cycleDelta}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                {/* Mini chart indicators */}
                                <div className="mt-3 flex items-end gap-1 h-8">
                                    {[40, 55, 45, 70, 65, 85, 75, 90].map((h, i) => (
                                        <div
                                            key={i}
                                            className="flex-1 rounded-t bg-gradient-to-t from-emerald-400 to-cyan-400 opacity-60"
                                            style={{ height: `${h}%` }}
                                        />
                                    ))}
                                </div>
                            </div>

                            {/* Enhanced Chart Section */}
                            <div className="relative mb-6 h-28 overflow-hidden rounded-2xl border border-white/10 bg-gradient-to-br from-white/5 to-transparent p-3 backdrop-blur-sm">
                                <div className="absolute inset-0 bg-gradient-to-t from-[#10b981]/30 via-[#10b981]/10 to-transparent" />
                                <div className="absolute inset-x-0 bottom-3 flex h-[75%] items-end justify-between px-2">
                                    {[55, 48, 62, 70, 90, 110, 100, 130, 125, 135, 150, 160].map((value, index) => (
                                        <div
                                            key={index}
                                            className="w-2 rounded-full bg-gradient-to-t from-[#10b981] via-[#34d399] to-[#6ee7b7] shadow-[0_0_15px_rgba(16,185,129,0.5)] transition-all duration-300 hover:scale-110"
                                            style={{
                                                height: `${Math.min(value, 160)}%`,
                                                animationDelay: `${index * 50}ms`
                                            }}
                                        />
                                    ))}
                                </div>
                                <div className="relative flex items-center justify-between">
                                    <span className="text-[10px] text-emerald-100/80 font-semibold uppercase tracking-wider">
                                        Performance Trend
                                    </span>
                                    <span className="text-[11px] font-bold text-emerald-300">
                                        {lifetimeDisplay.toFixed(3)} ETH lifetime
                                    </span>
                                </div>
                            </div>

                            {/* Time Period Selector - Enhanced */}
                            <div className="flex items-center justify-between text-[11px] mb-6">
                                {['1D', '1W', '1M', '3M', '6M', '1Y'].map((label) => (
                                    <button
                                        key={label}
                                        className={`group relative rounded-full border px-3 py-1.5 transition-all duration-300 ${label === '6M'
                                                ? 'border-white bg-white text-[#101c39] shadow-[0_12px_30px_rgba(255,255,255,0.35)] scale-105'
                                                : 'border-white/20 text-gray-300 hover:border-white/40 hover:text-white hover:bg-white/10'
                                            }`}
                                    >
                                        {label === '6M' && (
                                            <div className="absolute inset-0 rounded-full bg-gradient-to-r from-amber-400/30 to-fuchsia-400/30 blur-md" />
                                        )}
                                        <span className="relative font-semibold">{label}</span>
                                    </button>
                                ))}
                            </div>

                            {/* Stats Bar - DeFi Protocol Style */}
                            <div className="mt-6 flex items-center justify-between rounded-2xl border border-white/20 bg-gradient-to-r from-white/10 to-white/5 px-4 py-3 text-[11px] backdrop-blur-md shadow-inner">
                                <div className="flex items-center gap-2">
                                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-emerald-500/20">
                                        <TrendingUp className="h-4 w-4 text-emerald-300" />
                                    </div>
                                    <div>
                                        <p className="text-[9px] text-purple-200/70 uppercase tracking-wider">Performance</p>
                                        <p className="font-bold text-emerald-300">{cycleDelta}</p>
                                    </div>
                                </div>
                                <div className="h-6 w-px bg-white/20" />
                                <button
                                    className="flex items-center gap-2 text-xs font-semibold text-cyan-300 hover:text-cyan-200 transition-colors group"
                                    onClick={() => setShowLedgerModal(true)}
                                >
                                    <Eye className="h-4 w-4 group-hover:scale-110 transition-transform" />
                                    <span>Live ledger</span>
                                </button>
                            </div>

                            {/* Action Buttons - Enhanced with Animations */}
                            <div className="mt-6 grid grid-cols-2 gap-3">
                                <button
                                    className="group relative flex items-center justify-center gap-2 rounded-2xl bg-gradient-to-r from-[#6370ff] via-[#7d6eff] to-[#8a57ff] py-3.5 text-sm font-bold text-white shadow-[0_20px_45px_rgba(99,112,255,0.4)] transition-all duration-300 hover:shadow-[0_25px_55px_rgba(99,112,255,0.6)] hover:scale-105 active:scale-95 overflow-hidden"
                                    onClick={promptDonation}
                                >
                                    <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent translate-x-[-200%] group-hover:translate-x-[200%] transition-transform duration-1000" />
                                    <DollarSign className="relative h-5 w-5 group-hover:rotate-12 transition-transform" />
                                    <span className="relative">Donate Now</span>
                                </button>
                                <button
                                    className="group flex items-center justify-center gap-2 rounded-2xl border border-white/20 bg-white/10 py-3.5 text-sm font-semibold text-white backdrop-blur-md transition-all duration-300 hover:bg-white/20 hover:border-white/40 hover:scale-105 active:scale-95"
                                    onClick={openExplorer}
                                >
                                    <ExternalLink className="h-5 w-5 group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
                                    <span>{explorerLabel}</span>
                                </button>
                            </div>
                        </section>

                        {/* Transaction Feed - Enhanced FluxChain Style */}
                        <section className="rounded-3xl border border-white/10 bg-gradient-to-br from-white/10 to-white/5 backdrop-blur-md p-5 shadow-[0_8px_32px_rgba(0,0,0,0.2)]">
                            <div className="mb-4 flex items-center justify-between">
                                <div>
                                    <div className="flex items-center gap-2 mb-1">
                                        <div className="h-2 w-2 rounded-full bg-cyan-400 animate-pulse shadow-[0_0_10px_rgba(34,211,238,0.8)]" />
                                        <p className="text-[11px] uppercase tracking-[0.32em] text-blue-200/80 font-semibold">Live Feed</p>
                                    </div>
                                    <h2 className="text-lg font-bold text-white">Recent Transfers</h2>
                                </div>
                                <button
                                    className="group flex items-center gap-2 rounded-full border border-cyan-400/30 bg-cyan-500/10 px-3 py-1.5 text-xs font-semibold text-cyan-300 transition-all hover:bg-cyan-500/20 hover:scale-105"
                                    onClick={() => setShowLedgerModal(true)}
                                >
                                    <Eye className="h-4 w-4 group-hover:scale-110 transition-transform" />
                                    View all
                                </button>
                            </div>

                            <div className="space-y-2">
                                {ledgerPreview.map((tx, index) => (
                                    <div
                                        key={tx.id}
                                        className="group flex items-center justify-between rounded-2xl border border-white/10 bg-gradient-to-r from-white/5 to-transparent px-4 py-3 transition-all hover:border-white/20 hover:bg-white/10 hover:scale-[1.02]"
                                        style={{ animationDelay: `${index * 100}ms` }}
                                    >
                                        <div className="flex items-center gap-3">
                                            <div className={`flex h-10 w-10 items-center justify-center rounded-xl ${tx.type === 'donation'
                                                    ? 'bg-emerald-500/20 border border-emerald-400/30'
                                                    : 'bg-orange-500/20 border border-orange-400/30'
                                                } transition-transform group-hover:scale-110`}>
                                                {tx.type === 'donation' ? (
                                                    <TrendingUp className="h-5 w-5 text-emerald-300" />
                                                ) : (
                                                    <DollarSign className="h-5 w-5 text-orange-300" />
                                                )}
                                            </div>
                                            <div>
                                                <p className="text-sm font-semibold text-white">
                                                    {tx.type === 'donation' ? 'Donation' : 'Disbursement'}
                                                </p>
                                                <p className="text-xs text-gray-400 font-mono">{formatAddress(tx.address || '', 6)}</p>
                                                <p className="text-[11px] text-gray-500">
                                                    {formatDistanceToNow(tx.timestamp, { addSuffix: true })}
                                                </p>
                                            </div>
                                        </div>
                                        <div className="text-right">
                                            <p className={`text-sm font-bold ${tx.type === 'donation' ? 'text-emerald-300' : 'text-orange-300'
                                                }`}>
                                                {tx.type === 'donation' ? '+' : '-'}
                                                {tx.amount} ETH
                                            </p>
                                            <p className="text-[11px] text-gray-400">{formatFiatEstimate(tx.amount)}</p>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </section>
                    </div>
                </div>
            </div>

            {showMetaMaskPrompt && (
                <MetaMaskInstallPrompt onClose={() => setShowMetaMaskPrompt(false)} />
            )}

            {showDonationForm && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                    <div
                        className="absolute inset-0 bg-black/70 backdrop-blur-sm"
                        onClick={() => setShowDonationForm(false)}
                    />
                    <div className="relative w-full max-w-md rounded-3xl border border-white/10 bg-gradient-to-br from-[#1f2d53] via-[#162447] to-[#101c39] p-6 shadow-[0_30px_80px_rgba(10,14,36,0.65)]">
                        <div className="mb-4 flex items-center justify-between">
                            <h2 className="text-lg font-semibold text-white">Contribute to Elysian Reserve</h2>
                            <button
                                className="text-gray-400 hover:text-white"
                                onClick={() => setShowDonationForm(false)}
                            >
                                <X className="h-5 w-5" />
                            </button>
                        </div>
                        <DonationForm
                            className="pt-2"
                            onDonationSuccess={(amount, txHash) => handleDonationSuccess(amount, txHash)}
                        />
                    </div>
                </div>
            )}

            {showLedgerModal && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                    <div
                        className="absolute inset-0 bg-black/70 backdrop-blur-sm"
                        onClick={() => setShowLedgerModal(false)}
                    />
                    <div className="relative max-h-[85vh] w-full max-w-2xl overflow-y-auto rounded-3xl border border-white/10 bg-gradient-to-br from-[#1f2d53] via-[#162447] to-[#101c39] p-6 shadow-[0_30px_80px_rgba(10,14,36,0.65)]">
                        <div className="mb-4 flex items-center justify-between">
                            <h2 className="text-lg font-semibold text-white">Full Transparency Ledger</h2>
                            <button
                                className="text-gray-400 hover:text-white"
                                onClick={() => setShowLedgerModal(false)}
                            >
                                <X className="h-5 w-5" />
                            </button>
                        </div>
                        <TransactionLedger className="mt-4" refreshTrigger={ledgerRefreshToken} />
                    </div>
                </div>
            )}

            {showAdminPanel && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                    <div
                        className="absolute inset-0 bg-black/70 backdrop-blur-sm"
                        onClick={() => setShowAdminPanel(false)}
                    />
                    <div className="relative max-h-[85vh] w-full max-w-3xl overflow-y-auto rounded-3xl border border-white/10 bg-gradient-to-br from-[#1f2d53] via-[#162447] to-[#101c39] p-6 shadow-[0_30px_80px_rgba(10,14,36,0.65)]">
                        <div className="mb-4 flex items-center justify-between">
                            <h2 className="text-lg font-semibold text-white">Elysian Steward Controls</h2>
                            <button
                                className="text-gray-400 hover:text-white"
                                onClick={() => setShowAdminPanel(false)}
                            >
                                <X className="h-5 w-5" />
                            </button>
                        </div>
                        <AdminPanel className="mt-4" />
                    </div>
                </div>
            )}
        </div>
    );
};

export default ElysianDashboard;