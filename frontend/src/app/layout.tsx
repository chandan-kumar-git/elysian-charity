import '@/styles/globals.css';
import type { Metadata, Viewport } from 'next';
import { Inter } from 'next/font/google';

const inter = Inter({
    subsets: ['latin'],
    weight: ['300', '400', '500', '600', '700', '800', '900'],
    display: 'swap',
});

export const viewport: Viewport = {
    width: 'device-width',
    initialScale: 1,
    userScalable: false,
    themeColor: '#4f46e5',
}

export const metadata: Metadata = {
    title: 'Elysian - Crypto Charity Wallet',
    description: 'A sleek crypto wallet for transparent charity donations. Experience the future of blockchain philanthropy with beautiful dark UI.',
    keywords: 'crypto, wallet, charity, blockchain, ethereum, donations, transparency, NGO, smart contracts, DeFi',
    authors: [{ name: 'Elysian Crypto Team' }],
    openGraph: {
        title: 'Elysian - Crypto Charity Wallet',
        description: 'Experience the future of blockchain philanthropy with our sleek crypto wallet interface.',
        type: 'website',
        locale: 'en_US',
    },
    twitter: {
        card: 'summary_large_image',
        title: 'Elysian - Crypto Charity Wallet',
        description: 'Experience the future of blockchain philanthropy with our sleek crypto wallet interface.',
    },
};

export default function RootLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    return (
        <html lang="en" className="dark">
            <head>
                <link rel="icon" href="/favicon.ico" />
                <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
                <meta name="theme-color" content="#4f46e5" />
            </head>
            <body className={`${inter.className} bg-dark-bg text-dark-text antialiased`}>
                <div className="min-h-screen bg-gradient-dark">
                    {children}
                </div>
            </body>
        </html>
    );
}