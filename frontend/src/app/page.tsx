'use client';

import { WalletProvider } from '@/contexts/WalletContext';
import { Toaster } from 'react-hot-toast';
import ElysianDashboard from '../components/ElysianDashboard';

export default function App() {
    return (
        <WalletProvider>
            <div className="min-h-screen">
                <ElysianDashboard />
                <Toaster
                    position="top-center"
                    toastOptions={{
                        duration: 4000,
                        style: {
                            background: 'rgba(0, 0, 0, 0.8)',
                            color: '#fff',
                            backdropFilter: 'blur(10px)',
                        },
                    }}
                />
            </div>
        </WalletProvider>
    );
}