'use client';

import AdminPanel from '@/components/AdminPanel';
import DonationForm from '@/components/DonationForm';
import TransactionLedger from '@/components/TransactionLedger';
import WalletConnector from '@/components/WalletConnector';
import { WalletProvider } from '@/contexts/WalletContext';
import {
    BarChart3,
    ExternalLink,
    Github,
    Heart,
    Shield
} from 'lucide-react';
import { useState } from 'react';
import { Toaster } from 'react-hot-toast';

type TabType = 'donate' | 'transactions' | 'admin';

export default function App() {
    const [activeTab, setActiveTab] = useState<TabType>('donate');
    const [refreshTrigger, setRefreshTrigger] = useState(0);

    // Trigger refresh for transaction ledger when donations are made
    const handleDonationSuccess = () => {
        setRefreshTrigger(prev => prev + 1);
    };

    return (
        <WalletProvider>
            <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
                {/* Header */}
                <header className="bg-white/80 backdrop-blur-sm border-b border-gray-200 sticky top-0 z-50">
                    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div className="flex items-center justify-between h-16">
                            {/* Logo */}
                            <div className="flex items-center gap-3">
                                <div className="w-10 h-10 rounded-full bg-gradient-to-br from-charity-500 to-charity-600 flex items-center justify-center">
                                    <Heart className="h-6 w-6 text-white" />
                                </div>
                                <div>
                                    <h1 className="text-xl font-bold text-gray-900">Elysian</h1>
                                    <p className="text-xs text-gray-600">Charity Transparency</p>
                                </div>
                            </div>

                            {/* Navigation */}
                            <nav className="hidden md:flex items-center gap-1">
                                <button
                                    onClick={() => setActiveTab('donate')}
                                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${activeTab === 'donate'
                                            ? 'bg-charity-100 text-charity-700'
                                            : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                                        }`}
                                >
                                    <Heart className="h-4 w-4 inline mr-2" />
                                    Donate
                                </button>
                                <button
                                    onClick={() => setActiveTab('transactions')}
                                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${activeTab === 'transactions'
                                            ? 'bg-blue-100 text-blue-700'
                                            : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                                        }`}
                                >
                                    <BarChart3 className="h-4 w-4 inline mr-2" />
                                    Transactions
                                </button>
                                <button
                                    onClick={() => setActiveTab('admin')}
                                    className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${activeTab === 'admin'
                                            ? 'bg-red-100 text-red-700'
                                            : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                                        }`}
                                >
                                    <Shield className="h-4 w-4 inline mr-2" />
                                    Admin
                                </button>
                            </nav>

                            {/* Wallet Connector */}
                            <WalletConnector />
                        </div>

                        {/* Mobile Navigation */}
                        <div className="md:hidden pb-4">
                            <div className="flex space-x-1">
                                <button
                                    onClick={() => setActiveTab('donate')}
                                    className={`flex-1 px-3 py-2 rounded-lg text-sm font-medium transition-colors ${activeTab === 'donate'
                                            ? 'bg-charity-100 text-charity-700'
                                            : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                                        }`}
                                >
                                    <Heart className="h-4 w-4 inline mr-1" />
                                    Donate
                                </button>
                                <button
                                    onClick={() => setActiveTab('transactions')}
                                    className={`flex-1 px-3 py-2 rounded-lg text-sm font-medium transition-colors ${activeTab === 'transactions'
                                            ? 'bg-blue-100 text-blue-700'
                                            : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                                        }`}
                                >
                                    <BarChart3 className="h-4 w-4 inline mr-1" />
                                    Ledger
                                </button>
                                <button
                                    onClick={() => setActiveTab('admin')}
                                    className={`flex-1 px-3 py-2 rounded-lg text-sm font-medium transition-colors ${activeTab === 'admin'
                                            ? 'bg-red-100 text-red-700'
                                            : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
                                        }`}
                                >
                                    <Shield className="h-4 w-4 inline mr-1" />
                                    Admin
                                </button>
                            </div>
                        </div>
                    </div>
                </header>

                {/* Main Content */}
                <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                    {/* Hero Section - Only show on donate tab */}
                    {activeTab === 'donate' && (
                        <div className="text-center mb-8">
                            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
                                Transparent Charity Donations
                            </h2>
                            <p className="text-lg text-gray-600 max-w-2xl mx-auto mb-6">
                                Make secure, transparent donations to verified NGOs using blockchain technology.
                                Every transaction is recorded and verifiable on-chain.
                            </p>
                            <div className="flex flex-wrap justify-center gap-4 text-sm text-gray-600">
                                <div className="flex items-center gap-2">
                                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                                    Blockchain Verified
                                </div>
                                <div className="flex items-center gap-2">
                                    <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                                    100% Transparent
                                </div>
                                <div className="flex items-center gap-2">
                                    <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                                    Secure Donations
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Tab Content */}
                    {activeTab === 'donate' && (
                        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                            <DonationForm onDonationSuccess={handleDonationSuccess} />
                            <div className="space-y-6">
                                {/* Quick Stats */}
                                <div className="card">
                                    <h3 className="text-lg font-semibold text-gray-900 mb-4">Platform Impact</h3>
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="text-center">
                                            <div className="text-2xl font-bold text-charity-600">***</div>
                                            <div className="text-sm text-gray-600">Total Donated</div>
                                        </div>
                                        <div className="text-center">
                                            <div className="text-2xl font-bold text-blue-600">***</div>
                                            <div className="text-sm text-gray-600">Verified NGOs</div>
                                        </div>
                                    </div>
                                </div>

                                {/* How it Works */}
                                <div className="card">
                                    <h3 className="text-lg font-semibold text-gray-900 mb-4">How it Works</h3>
                                    <div className="space-y-4">
                                        <div className="flex gap-3">
                                            <div className="w-8 h-8 rounded-full bg-charity-100 flex items-center justify-center flex-shrink-0">
                                                <span className="text-charity-600 font-semibold text-sm">1</span>
                                            </div>
                                            <div>
                                                <h4 className="font-medium text-gray-900">Connect Wallet</h4>
                                                <p className="text-sm text-gray-600">Connect your MetaMask wallet to the platform</p>
                                            </div>
                                        </div>
                                        <div className="flex gap-3">
                                            <div className="w-8 h-8 rounded-full bg-charity-100 flex items-center justify-center flex-shrink-0">
                                                <span className="text-charity-600 font-semibold text-sm">2</span>
                                            </div>
                                            <div>
                                                <h4 className="font-medium text-gray-900">Choose Amount</h4>
                                                <p className="text-sm text-gray-600">Select your donation amount in ETH</p>
                                            </div>
                                        </div>
                                        <div className="flex gap-3">
                                            <div className="w-8 h-8 rounded-full bg-charity-100 flex items-center justify-center flex-shrink-0">
                                                <span className="text-charity-600 font-semibold text-sm">3</span>
                                            </div>
                                            <div>
                                                <h4 className="font-medium text-gray-900">Donate Securely</h4>
                                                <p className="text-sm text-gray-600">Your donation is recorded on the blockchain</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}

                    {activeTab === 'transactions' && (
                        <TransactionLedger refreshTrigger={refreshTrigger} />
                    )}

                    {activeTab === 'admin' && (
                        <AdminPanel />
                    )}
                </main>

                {/* Footer */}
                <footer className="bg-gray-50 border-t border-gray-200 mt-16">
                    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                            {/* About */}
                            <div>
                                <div className="flex items-center gap-2 mb-4">
                                    <Heart className="h-5 w-5 text-charity-600" />
                                    <span className="font-semibold text-gray-900">Elysian</span>
                                </div>
                                <p className="text-sm text-gray-600 mb-4">
                                    A blockchain-based platform for transparent charity donations.
                                    Built with trust, transparency, and accountability at its core.
                                </p>
                                <div className="flex gap-3">
                                    <a
                                        href="https://github.com"
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className="text-gray-400 hover:text-gray-600 transition-colors"
                                    >
                                        <Github className="h-5 w-5" />
                                    </a>
                                    <a
                                        href="https://sepolia.etherscan.io"
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className="text-gray-400 hover:text-gray-600 transition-colors"
                                    >
                                        <ExternalLink className="h-5 w-5" />
                                    </a>
                                </div>
                            </div>

                            {/* Features */}
                            <div>
                                <h3 className="font-semibold text-gray-900 mb-4">Features</h3>
                                <ul className="space-y-2 text-sm text-gray-600">
                                    <li>✅ Blockchain transparency</li>
                                    <li>✅ NGO verification system</li>
                                    <li>✅ Real-time transaction tracking</li>
                                    <li>✅ Secure smart contracts</li>
                                    <li>✅ Admin oversight tools</li>
                                </ul>
                            </div>

                            {/* Technical */}
                            <div>
                                <h3 className="font-semibold text-gray-900 mb-4">Technology</h3>
                                <ul className="space-y-2 text-sm text-gray-600">
                                    <li>🔗 Ethereum Blockchain</li>
                                    <li>📝 Solidity Smart Contracts</li>
                                    <li>⚡ Next.js Frontend</li>
                                    <li>🦊 MetaMask Integration</li>
                                    <li>🎨 TailwindCSS Design</li>
                                </ul>
                            </div>
                        </div>

                        <div className="border-t border-gray-200 mt-8 pt-8 text-center">
                            <p className="text-sm text-gray-600">
                                © 2024 Elysian Charity Platform. Built for transparency and trust.
                            </p>
                        </div>
                    </div>
                </footer>

                {/* Toast Notifications */}
                <Toaster
                    position="bottom-right"
                    toastOptions={{
                        duration: 4000,
                        style: {
                            background: '#fff',
                            color: '#374151',
                            boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
                        },
                    }}
                />
            </div>
        </WalletProvider>
    );
}