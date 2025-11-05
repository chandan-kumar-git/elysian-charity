'use client';

import { formatAddress, useWallet } from '@/contexts/WalletContext';
import { AlertCircle, CheckCircle, RefreshCw, Wallet } from 'lucide-react';
import { useState } from 'react';

interface WalletConnectorProps {
    className?: string;
}

export default function WalletConnector({ className = '' }: WalletConnectorProps) {
    const {
        isConnected,
        isConnecting,
        account,
        networkName,
        isCorrectNetwork,
        connect,
        disconnect,
        switchNetwork,
    } = useWallet();

    const [isDropdownOpen, setIsDropdownOpen] = useState(false);

    if (!isConnected) {
        return (
            <div className={`flex items-center gap-4 ${className}`}>
                <button
                    onClick={connect}
                    disabled={isConnecting}
                    className="btn btn-primary btn-lg group relative overflow-hidden"
                >
                    <div className="flex items-center gap-2">
                        {isConnecting ? (
                            <RefreshCw className="h-5 w-5 animate-spin" />
                        ) : (
                            <Wallet className="h-5 w-5" />
                        )}
                        <span className="font-medium">
                            {isConnecting ? 'Connecting...' : 'Connect Wallet'}
                        </span>
                    </div>

                    {/* Animated background */}
                    <div className="absolute inset-0 bg-primary-700 transform translate-x-full group-hover:translate-x-0 transition-transform duration-300 ease-out -z-10" />
                </button>

                {/* MetaMask info */}
                <div className="hidden sm:flex items-center gap-2 text-sm text-gray-500">
                    <Wallet className="h-4 w-4" />
                    <span>MetaMask Required</span>
                </div>
            </div>
        );
    }

    return (
        <div className={`relative ${className}`}>
            <div className="flex items-center gap-3">
                {/* Network Status Indicator */}
                <div className="flex items-center gap-2">
                    <div className={`status-dot ${isCorrectNetwork ? 'status-success' : 'status-error'}`} />
                    <span className="text-sm font-medium text-gray-700">
                        {networkName}
                    </span>
                    {!isCorrectNetwork && (
                        <button
                            onClick={switchNetwork}
                            className="text-xs text-red-600 hover:text-red-800 underline ml-1"
                            title="Switch to correct network"
                        >
                            Switch
                        </button>
                    )}
                </div>

                {/* Account Button */}
                <div className="relative">
                    <button
                        onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                        className="flex items-center gap-3 bg-white border border-gray-200 rounded-lg px-4 py-2 hover:border-gray-300 transition-colors focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                    >
                        {/* Account Avatar */}
                        <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary-500 to-charity-500 flex items-center justify-center">
                            <span className="text-white text-sm font-medium">
                                {account ? account.slice(2, 4).toUpperCase() : '??'}
                            </span>
                        </div>

                        {/* Account Info */}
                        <div className="flex flex-col items-start">
                            <div className="flex items-center gap-2">
                                <span className="text-sm font-medium text-gray-900">
                                    {formatAddress(account || '')}
                                </span>
                                {isCorrectNetwork ? (
                                    <CheckCircle className="h-4 w-4 text-charity-500" />
                                ) : (
                                    <AlertCircle className="h-4 w-4 text-red-500" />
                                )}
                            </div>
                            <span className="text-xs text-gray-500">Connected</span>
                        </div>

                        {/* Dropdown Arrow */}
                        <svg
                            className={`h-4 w-4 text-gray-400 transition-transform ${isDropdownOpen ? 'transform rotate-180' : ''
                                }`}
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                        >
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                        </svg>
                    </button>

                    {/* Dropdown Menu */}
                    {isDropdownOpen && (
                        <>
                            {/* Backdrop */}
                            <div
                                className="fixed inset-0 z-10"
                                onClick={() => setIsDropdownOpen(false)}
                            />

                            {/* Menu */}
                            <div className="absolute right-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-200 z-20 animate-fade-in">
                                <div className="p-4">
                                    {/* Account Details */}
                                    <div className="mb-4">
                                        <label className="block text-xs font-medium text-gray-500 uppercase tracking-wide mb-1">
                                            Account Address
                                        </label>
                                        <div className="flex items-center gap-2">
                                            <code className="text-sm font-mono text-gray-900 bg-gray-50 px-2 py-1 rounded">
                                                {formatAddress(account || '', 6)}
                                            </code>
                                            <button
                                                onClick={() => {
                                                    navigator.clipboard.writeText(account || '');
                                                    setIsDropdownOpen(false);
                                                }}
                                                className="text-xs text-primary-600 hover:text-primary-800"
                                            >
                                                Copy
                                            </button>
                                        </div>
                                    </div>

                                    {/* Network Status */}
                                    <div className="mb-4">
                                        <label className="block text-xs font-medium text-gray-500 uppercase tracking-wide mb-1">
                                            Network
                                        </label>
                                        <div className="flex items-center gap-2">
                                            <div className={`status-dot ${isCorrectNetwork ? 'status-success' : 'status-error'}`} />
                                            <span className="text-sm text-gray-900">{networkName}</span>
                                        </div>
                                        {!isCorrectNetwork && (
                                            <button
                                                onClick={() => {
                                                    switchNetwork();
                                                    setIsDropdownOpen(false);
                                                }}
                                                className="btn btn-sm btn-primary mt-2 w-full"
                                            >
                                                Switch Network
                                            </button>
                                        )}
                                    </div>

                                    {/* Actions */}
                                    <div className="space-y-2">
                                        <button
                                            onClick={() => {
                                                window.open(
                                                    `https://sepolia.etherscan.io/address/${account}`,
                                                    '_blank'
                                                );
                                                setIsDropdownOpen(false);
                                            }}
                                            className="w-full text-left px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 rounded-md transition-colors"
                                        >
                                            View on Etherscan
                                        </button>

                                        <button
                                            onClick={() => {
                                                disconnect();
                                                setIsDropdownOpen(false);
                                            }}
                                            className="w-full text-left px-3 py-2 text-sm text-red-600 hover:bg-red-50 rounded-md transition-colors"
                                        >
                                            Disconnect Wallet
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </>
                    )}
                </div>
            </div>

            {/* Network Warning Banner */}
            {isConnected && !isCorrectNetwork && (
                <div className="absolute top-full left-0 right-0 mt-2 bg-red-50 border border-red-200 rounded-lg p-3 animate-slide-up">
                    <div className="flex items-center gap-2">
                        <AlertCircle className="h-4 w-4 text-red-500 flex-shrink-0" />
                        <div className="flex-1">
                            <p className="text-sm text-red-800">
                                Wrong network detected. Please switch to the correct network.
                            </p>
                        </div>
                        <button
                            onClick={switchNetwork}
                            className="btn btn-sm bg-red-100 text-red-700 hover:bg-red-200 border-red-200"
                        >
                            Switch
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
}