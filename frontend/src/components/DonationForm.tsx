'use client';

import { useWallet } from '@/contexts/WalletContext';
import { ethers } from 'ethers';
import { AlertCircle, CheckCircle, Heart, Loader2, Send } from 'lucide-react';
import React, { useCallback, useState } from 'react';
import toast from 'react-hot-toast';

// Contract ABI (minimal for donation function)
const CONTRACT_ABI = [
    'function donate() external payable',
    'function getContractBalance() external view returns (uint256)',
    'event DonationReceived(address indexed donor, uint256 amount, uint256 timestamp, uint256 newTotalDonations)'
];

interface DonationFormProps {
    className?: string;
    onDonationSuccess?: (amount: string, txHash: string) => void;
}

export default function DonationForm({ className = '', onDonationSuccess }: DonationFormProps) {
    const { isConnected, isCorrectNetwork, signer, account } = useWallet();

    const [amount, setAmount] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [lastDonation, setLastDonation] = useState<{
        amount: string;
        txHash: string;
        timestamp: number;
    } | null>(null);

    // Quick amount buttons
    const quickAmounts = ['0.01', '0.05', '0.1', '0.5', '1.0'];

    // Validate donation amount
    const validateAmount = useCallback((value: string): string | null => {
        if (!value || value.trim() === '') {
            return 'Please enter an amount';
        }

        const numValue = parseFloat(value);
        if (isNaN(numValue) || numValue <= 0) {
            return 'Amount must be greater than 0';
        }

        if (numValue < 0.001) {
            return 'Minimum donation is 0.001 ETH';
        }

        if (numValue > 1000) {
            return 'Maximum donation is 1000 ETH';
        }

        return null;
    }, []);

    // Handle donation submission
    const handleDonate = useCallback(async (e: React.FormEvent) => {
        e.preventDefault();

        if (!isConnected) {
            toast.error('Please connect your wallet first');
            return;
        }

        if (!isCorrectNetwork) {
            toast.error('Please switch to the correct network');
            return;
        }

        const validationError = validateAmount(amount);
        if (validationError) {
            toast.error(validationError);
            return;
        }

        if (!signer) {
            toast.error('No signer available');
            return;
        }

        const contractAddress = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS;
        if (!contractAddress) {
            toast.error('Contract address not configured');
            return;
        }

        setIsSubmitting(true);
        const loadingToast = toast.loading('Processing donation...');

        try {
            // Create contract instance
            const contract = new ethers.Contract(contractAddress, CONTRACT_ABI, signer);

            // Convert amount to wei
            const donationAmount = ethers.parseEther(amount);

            // Estimate gas
            const gasEstimate = await contract.donate.estimateGas({ value: donationAmount });
            const gasLimit = gasEstimate * BigInt(120) / BigInt(100); // Add 20% buffer

            // Send transaction
            const tx = await contract.donate({
                value: donationAmount,
                gasLimit
            });

            toast.dismiss(loadingToast);
            toast.loading('Waiting for confirmation...', { id: 'confirmation' });

            // Wait for confirmation
            const receipt = await tx.wait();

            toast.dismiss('confirmation');

            if (receipt.status === 1) {
                // Success
                setLastDonation({
                    amount,
                    txHash: receipt.hash,
                    timestamp: Date.now()
                });

                setAmount('');

                toast.success(
                    `Donation of ${amount} ETH successful!`,
                    { duration: 5000 }
                );

                // Call success callback
                onDonationSuccess?.(amount, receipt.hash);

            } else {
                throw new Error('Transaction failed');
            }

        } catch (error: any) {
            console.error('Donation failed:', error);
            toast.dismiss(loadingToast);
            toast.dismiss('confirmation');

            let errorMessage = 'Donation failed';

            if (error.code === 'ACTION_REJECTED' || error.code === 4001) {
                errorMessage = 'Transaction rejected by user';
            } else if (error.code === 'INSUFFICIENT_FUNDS') {
                errorMessage = 'Insufficient funds in wallet';
            } else if (error.message?.includes('insufficient funds')) {
                errorMessage = 'Insufficient funds for transaction';
            } else if (error.reason) {
                errorMessage = error.reason;
            } else if (error.message) {
                errorMessage = error.message;
            }

            toast.error(errorMessage);
        } finally {
            setIsSubmitting(false);
        }
    }, [isConnected, isCorrectNetwork, signer, amount, validateAmount, onDonationSuccess]);

    // Handle quick amount selection
    const handleQuickAmount = useCallback((quickAmount: string) => {
        setAmount(quickAmount);
    }, []);

    return (
        <div className={`card ${className}`}>
            <div className="flex items-center gap-3 mb-6">
                <div className="w-12 h-12 rounded-full bg-gradient-to-br from-charity-500 to-charity-600 flex items-center justify-center">
                    <Heart className="h-6 w-6 text-white" />
                </div>
                <div>
                    <h3 className="text-xl font-semibold text-gray-900">Make a Donation</h3>
                    <p className="text-sm text-gray-600">Support transparency in charity</p>
                </div>
            </div>

            {/* Connection Status */}
            {!isConnected && (
                <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 mb-6">
                    <div className="flex items-center gap-2">
                        <AlertCircle className="h-5 w-5 text-amber-600" />
                        <p className="text-sm text-amber-800">
                            Please connect your wallet to make a donation
                        </p>
                    </div>
                </div>
            )}

            {isConnected && !isCorrectNetwork && (
                <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
                    <div className="flex items-center gap-2">
                        <AlertCircle className="h-5 w-5 text-red-600" />
                        <p className="text-sm text-red-800">
                            Please switch to the correct network to make a donation
                        </p>
                    </div>
                </div>
            )}

            {/* Donation Form */}
            <form onSubmit={handleDonate} className="space-y-6">
                {/* Amount Input */}
                <div>
                    <label htmlFor="amount" className="block text-sm font-medium text-gray-700 mb-2">
                        Donation Amount (ETH)
                    </label>
                    <div className="relative">
                        <input
                            id="amount"
                            type="number"
                            step="0.001"
                            min="0.001"
                            max="1000"
                            value={amount}
                            onChange={(e) => setAmount(e.target.value)}
                            placeholder="0.1"
                            className="input pr-16"
                            disabled={!isConnected || !isCorrectNetwork || isSubmitting}
                        />
                        <div className="absolute inset-y-0 right-0 flex items-center pr-3">
                            <span className="text-sm font-medium text-gray-500">ETH</span>
                        </div>
                    </div>

                    {/* Validation Message */}
                    {amount && validateAmount(amount) && (
                        <p className="mt-1 text-sm text-red-600">
                            {validateAmount(amount)}
                        </p>
                    )}
                </div>

                {/* Quick Amount Buttons */}
                <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                        Quick Select
                    </label>
                    <div className="flex flex-wrap gap-2">
                        {quickAmounts.map((quickAmount) => (
                            <button
                                key={quickAmount}
                                type="button"
                                onClick={() => handleQuickAmount(quickAmount)}
                                disabled={!isConnected || !isCorrectNetwork || isSubmitting}
                                className={`btn btn-sm transition-all ${amount === quickAmount
                                    ? 'bg-charity-100 text-charity-700 border-charity-300'
                                    : 'btn-secondary'
                                    }`}
                            >
                                {quickAmount} ETH
                            </button>
                        ))}
                    </div>
                </div>

                {/* USD Estimation (placeholder) */}
                {amount && !validateAmount(amount) && (
                    <div className="bg-gray-50 rounded-lg p-3">
                        <p className="text-sm text-gray-600">
                            ≈ ${(parseFloat(amount) * 2500).toLocaleString(undefined, {
                                minimumFractionDigits: 2,
                                maximumFractionDigits: 2
                            })} USD
                            <span className="text-xs text-gray-500 ml-1">(estimated)</span>
                        </p>
                    </div>
                )}

                {/* Submit Button */}
                <button
                    type="submit"
                    disabled={
                        !isConnected ||
                        !isCorrectNetwork ||
                        isSubmitting ||
                        !amount ||
                        validateAmount(amount) !== null
                    }
                    className="btn btn-charity btn-lg w-full group relative overflow-hidden"
                >
                    <div className="flex items-center justify-center gap-2">
                        {isSubmitting ? (
                            <Loader2 className="h-5 w-5 animate-spin" />
                        ) : (
                            <Send className="h-5 w-5 group-hover:translate-x-1 transition-transform" />
                        )}
                        <span className="font-medium">
                            {isSubmitting ? 'Processing...' : 'Donate Now'}
                        </span>
                    </div>

                    {/* Animated background */}
                    <div className="absolute inset-0 bg-charity-700 transform translate-x-full group-hover:translate-x-0 transition-transform duration-300 ease-out -z-10" />
                </button>
            </form>

            {/* Last Donation Success */}
            {lastDonation && (
                <div className="mt-6 bg-charity-50 border border-charity-200 rounded-lg p-4 animate-fade-in">
                    <div className="flex items-center gap-2 mb-2">
                        <CheckCircle className="h-5 w-5 text-charity-600" />
                        <span className="font-medium text-charity-800">Donation Successful!</span>
                    </div>
                    <div className="space-y-1 text-sm text-charity-700">
                        <p>Amount: {lastDonation.amount} ETH</p>
                        <p className="flex items-center gap-1">
                            Transaction:
                            <a
                                href={`https://sepolia.etherscan.io/tx/${lastDonation.txHash}`}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="text-charity-600 hover:text-charity-800 underline font-mono"
                            >
                                {lastDonation.txHash.slice(0, 10)}...
                            </a>
                        </p>
                    </div>
                </div>
            )}

            {/* Info Section */}
            <div className="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
                <h4 className="font-medium text-blue-900 mb-2">💡 How it works</h4>
                <ul className="text-sm text-blue-800 space-y-1">
                    <li>• Your donation is recorded on the blockchain</li>
                    <li>• All transactions are publicly verifiable</li>
                    <li>• Funds are held securely until distributed</li>
                    <li>• You can track your impact in real-time</li>
                </ul>
            </div>
        </div>
    );
}