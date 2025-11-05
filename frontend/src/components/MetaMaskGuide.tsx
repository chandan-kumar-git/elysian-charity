'use client';

import { Check, ChevronRight, Download, Globe, Lock, Shield } from 'lucide-react';
import React, { useState } from 'react';

const MetaMaskGuide: React.FC = () => {
    const [currentStep, setCurrentStep] = useState(0);

    const steps = [
        {
            title: "What is MetaMask?",
            icon: <Shield className="w-8 h-8 text-blue-400" />,
            content: (
                <div className="space-y-3">
                    <p className="text-gray-300">
                        MetaMask is a secure cryptocurrency wallet that runs in your browser.
                        It allows you to interact with blockchain applications like Elysian.
                    </p>
                    <div className="space-y-2">
                        <div className="flex items-center space-x-2">
                            <Check className="w-4 h-4 text-green-400" />
                            <span className="text-sm text-gray-300">Store and manage your crypto safely</span>
                        </div>
                        <div className="flex items-center space-x-2">
                            <Check className="w-4 h-4 text-green-400" />
                            <span className="text-sm text-gray-300">Connect to decentralized apps (dApps)</span>
                        </div>
                        <div className="flex items-center space-x-2">
                            <Check className="w-4 h-4 text-green-400" />
                            <span className="text-sm text-gray-300">Make transparent donations on blockchain</span>
                        </div>
                    </div>
                </div>
            )
        },
        {
            title: "Install MetaMask",
            icon: <Download className="w-8 h-8 text-green-400" />,
            content: (
                <div className="space-y-4">
                    <p className="text-gray-300">
                        Click the button below to download MetaMask from the official website:
                    </p>
                    <button
                        onClick={() => window.open('https://metamask.io/download/', '_blank')}
                        className="w-full bg-gradient-to-r from-orange-500 to-yellow-600 hover:from-orange-600 hover:to-yellow-700 rounded-xl py-3 px-4 text-white font-medium transition-all duration-200 flex items-center justify-center space-x-2"
                    >
                        <Download className="w-5 h-5" />
                        <span>Download MetaMask</span>
                    </button>
                    <p className="text-xs text-gray-400 text-center">
                        Available for Chrome, Firefox, Safari, and mobile devices
                    </p>
                </div>
            )
        },
        {
            title: "Setup Your Wallet",
            icon: <Lock className="w-8 h-8 text-purple-400" />,
            content: (
                <div className="space-y-3">
                    <p className="text-gray-300">
                        After installing MetaMask, you'll need to:
                    </p>
                    <div className="space-y-2">
                        <div className="flex items-start space-x-3">
                            <span className="bg-purple-500/20 text-purple-400 text-xs px-2 py-1 rounded-full font-medium">1</span>
                            <span className="text-sm text-gray-300">Create a new wallet or import existing one</span>
                        </div>
                        <div className="flex items-start space-x-3">
                            <span className="bg-purple-500/20 text-purple-400 text-xs px-2 py-1 rounded-full font-medium">2</span>
                            <span className="text-sm text-gray-300">Secure your seed phrase (write it down safely)</span>
                        </div>
                        <div className="flex items-start space-x-3">
                            <span className="bg-purple-500/20 text-purple-400 text-xs px-2 py-1 rounded-full font-medium">3</span>
                            <span className="text-sm text-gray-300">Add some ETH to make donations</span>
                        </div>
                    </div>
                </div>
            )
        },
        {
            title: "Connect to Elysian",
            icon: <Globe className="w-8 h-8 text-cyan-400" />,
            content: (
                <div className="space-y-3">
                    <p className="text-gray-300">
                        Once MetaMask is set up, return to Elysian and:
                    </p>
                    <div className="space-y-2">
                        <div className="flex items-start space-x-3">
                            <span className="bg-cyan-500/20 text-cyan-400 text-xs px-2 py-1 rounded-full font-medium">1</span>
                            <span className="text-sm text-gray-300">Refresh this page</span>
                        </div>
                        <div className="flex items-start space-x-3">
                            <span className="bg-cyan-500/20 text-cyan-400 text-xs px-2 py-1 rounded-full font-medium">2</span>
                            <span className="text-sm text-gray-300">Click "Connect Wallet" in the top right</span>
                        </div>
                        <div className="flex items-start space-x-3">
                            <span className="bg-cyan-500/20 text-cyan-400 text-xs px-2 py-1 rounded-full font-medium">3</span>
                            <span className="text-sm text-gray-300">Start making transparent donations!</span>
                        </div>
                    </div>
                </div>
            )
        }
    ];

    return (
        <div className="max-w-md mx-auto p-6">
            {/* Progress Indicator */}
            <div className="flex items-center justify-between mb-6">
                {steps.map((_, index) => (
                    <div key={index} className="flex items-center">
                        <div
                            className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium transition-colors ${index <= currentStep
                                    ? 'bg-blue-500 text-white'
                                    : 'bg-gray-700 text-gray-400'
                                }`}
                        >
                            {index + 1}
                        </div>
                        {index < steps.length - 1 && (
                            <div
                                className={`w-16 h-1 mx-2 transition-colors ${index < currentStep ? 'bg-blue-500' : 'bg-gray-700'
                                    }`}
                            />
                        )}
                    </div>
                ))}
            </div>

            {/* Current Step */}
            <div className="bg-white/5 rounded-xl p-6 border border-white/10">
                <div className="flex items-center space-x-3 mb-4">
                    {steps[currentStep].icon}
                    <h3 className="text-xl font-semibold text-white">{steps[currentStep].title}</h3>
                </div>
                {steps[currentStep].content}
            </div>

            {/* Navigation */}
            <div className="flex justify-between items-center mt-6">
                <button
                    onClick={() => setCurrentStep(Math.max(0, currentStep - 1))}
                    disabled={currentStep === 0}
                    className="px-4 py-2 bg-white/10 hover:bg-white/20 disabled:opacity-50 disabled:cursor-not-allowed rounded-lg text-white transition-colors"
                >
                    Previous
                </button>

                <span className="text-sm text-gray-400">
                    {currentStep + 1} of {steps.length}
                </span>

                <button
                    onClick={() => setCurrentStep(Math.min(steps.length - 1, currentStep + 1))}
                    disabled={currentStep === steps.length - 1}
                    className="px-4 py-2 bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed rounded-lg text-white transition-colors flex items-center space-x-1"
                >
                    <span>Next</span>
                    <ChevronRight className="w-4 h-4" />
                </button>
            </div>
        </div>
    );
};

export default MetaMaskGuide;