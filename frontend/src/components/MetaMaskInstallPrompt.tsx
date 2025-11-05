'use client';

import { AlertCircle, BookOpen, Download, ExternalLink } from 'lucide-react';
import React, { useState } from 'react';
import MetaMaskGuide from './MetaMaskGuide';

interface MetaMaskInstallPromptProps {
    onClose?: () => void;
}

const MetaMaskInstallPrompt: React.FC<MetaMaskInstallPromptProps> = ({ onClose }) => {
    const [showGuide, setShowGuide] = useState(false);

    const installMetaMask = () => {
        window.open('https://metamask.io/download/', '_blank');
    };

    if (showGuide) {
        return (
            <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
                {/* Backdrop */}
                <div
                    className="absolute inset-0 bg-black bg-opacity-50 backdrop-blur-sm"
                    onClick={() => setShowGuide(false)}
                />

                {/* Modal */}
                <div className="relative bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-800 rounded-2xl w-full max-w-lg border border-white/20 max-h-[90vh] overflow-y-auto">
                    <div className="absolute inset-0 bg-black bg-opacity-20 rounded-2xl" />

                    <div className="relative z-10">
                        {/* Header */}
                        <div className="flex items-center justify-between p-6 border-b border-white/10">
                            <h2 className="text-xl font-bold text-white">MetaMask Setup Guide</h2>
                            <button
                                onClick={() => setShowGuide(false)}
                                className="p-2 rounded-full hover:bg-white/10 transition-colors"
                            >
                                <AlertCircle className="w-5 h-5 text-gray-400" />
                            </button>
                        </div>

                        {/* Guide Content */}
                        <MetaMaskGuide />
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
            {/* Backdrop */}
            <div className="absolute inset-0 bg-black bg-opacity-50 backdrop-blur-sm" />

            {/* Modal */}
            <div className="relative bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-800 rounded-2xl p-6 w-full max-w-md border border-white/20">
                <div className="absolute inset-0 bg-black bg-opacity-20 rounded-2xl" />

                <div className="relative z-10 text-center">
                    {/* MetaMask Icon */}
                    <div className="w-20 h-20 mx-auto mb-4 rounded-full bg-gradient-to-r from-orange-500 to-yellow-600 flex items-center justify-center">
                        <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center">
                            <div className="w-8 h-8 bg-gradient-to-r from-orange-500 to-yellow-600 rounded-full"></div>
                        </div>
                    </div>

                    {/* Title */}
                    <h2 className="text-2xl font-bold text-white mb-2">MetaMask Required</h2>

                    {/* Description */}
                    <p className="text-gray-300 mb-6 leading-relaxed">
                        To use the Elysian Charity Transparency System, you need MetaMask wallet installed.
                        MetaMask is a secure crypto wallet that lets you interact with blockchain applications.
                    </p>

                    {/* Features */}
                    <div className="text-left mb-6 space-y-2">
                        <div className="flex items-center space-x-3">
                            <div className="w-2 h-2 bg-green-400 rounded-full"></div>
                            <span className="text-sm text-gray-300">Secure cryptocurrency wallet</span>
                        </div>
                        <div className="flex items-center space-x-3">
                            <div className="w-2 h-2 bg-green-400 rounded-full"></div>
                            <span className="text-sm text-gray-300">Connect to decentralized apps</span>
                        </div>
                        <div className="flex items-center space-x-3">
                            <div className="w-2 h-2 bg-green-400 rounded-full"></div>
                            <span className="text-sm text-gray-300">Make transparent donations</span>
                        </div>
                    </div>

                    {/* Install Button */}
                    <button
                        onClick={installMetaMask}
                        className="w-full bg-gradient-to-r from-orange-500 to-yellow-600 hover:from-orange-600 hover:to-yellow-700 rounded-xl py-3 px-4 text-white font-medium transition-all duration-200 flex items-center justify-center space-x-2 mb-3"
                    >
                        <Download className="w-5 h-5" />
                        <span>Install MetaMask</span>
                        <ExternalLink className="w-4 h-4" />
                    </button>

                    {/* Guide Button */}
                    <button
                        onClick={() => setShowGuide(true)}
                        className="w-full bg-white/10 hover:bg-white/20 rounded-xl py-3 px-4 text-white font-medium transition-all duration-200 flex items-center justify-center space-x-2 mb-4"
                    >
                        <BookOpen className="w-5 h-5" />
                        <span>Step-by-Step Guide</span>
                    </button>

                    {/* Alternative Instructions */}
                    <div className="text-xs text-gray-400 space-y-1">
                        <p>Already have MetaMask installed?</p>
                        <p>Refresh this page after installation</p>
                    </div>

                    {/* Close button if provided */}
                    {onClose && (
                        <button
                            onClick={onClose}
                            className="absolute top-4 right-4 p-2 rounded-full hover:bg-white/10 transition-colors"
                        >
                            <AlertCircle className="w-5 h-5 text-gray-400" />
                        </button>
                    )}
                </div>
            </div>
        </div>
    );
};

export default MetaMaskInstallPrompt;