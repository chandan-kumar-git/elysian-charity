/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
        './src/components/**/*.{js,ts,jsx,tsx,mdx}',
        './src/app/**/*.{js,ts,jsx,tsx,mdx}',
    ],
    darkMode: 'class',
    theme: {
        extend: {
            colors: {
                // Dark crypto theme colors
                dark: {
                    bg: '#0a0b1e',
                    card: '#1a1b3a',
                    surface: '#252659',
                    border: '#3d3f7d',
                    text: '#e4e4e7',
                    muted: '#9ca3af',
                },
                crypto: {
                    blue: '#4f46e5',
                    purple: '#7c3aed',
                    green: '#10b981',
                    red: '#ef4444',
                    gold: '#f59e0b',
                    cyan: '#06b6d4',
                },
                primary: {
                    50: '#eff6ff',
                    100: '#dbeafe',
                    200: '#bfdbfe',
                    300: '#93c5fd',
                    400: '#60a5fa',
                    500: '#3b82f6',
                    600: '#2563eb',
                    700: '#1d4ed8',
                    800: '#1e40af',
                    900: '#1e3a8a',
                },
                charity: {
                    50: '#f0fdf4',
                    100: '#dcfce7',
                    200: '#bbf7d0',
                    300: '#86efac',
                    400: '#4ade80',
                    500: '#22c55e',
                    600: '#16a34a',
                    700: '#15803d',
                    800: '#166534',
                    900: '#14532d',
                },
                accent: {
                    50: '#fefce8',
                    100: '#fef9c3',
                    200: '#fef08a',
                    300: '#fde047',
                    400: '#facc15',
                    500: '#eab308',
                    600: '#ca8a04',
                    700: '#a16207',
                    800: '#854d0e',
                    900: '#713f12',
                }
            },
            fontFamily: {
                sans: ['Inter', 'system-ui', 'sans-serif'],
                display: ['Lexend', 'system-ui', 'sans-serif'],
            },
            backgroundImage: {
                'gradient-crypto': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                'gradient-dark': 'linear-gradient(135deg, #0a0b1e 0%, #1a1b3a 50%, #252659 100%)',
                'gradient-card': 'linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%)',
                'gradient-glow': 'radial-gradient(circle at 50% 50%, rgba(79, 70, 229, 0.3) 0%, transparent 50%)',
            },
            backdropBlur: {
                xs: '2px',
                sm: '4px',
                md: '8px',
                lg: '12px',
                xl: '16px',
                '2xl': '24px',
                '3xl': '40px',
            },
            boxShadow: {
                'glow': '0 0 20px rgba(79, 70, 229, 0.3)',
                'glow-lg': '0 0 40px rgba(79, 70, 229, 0.4)',
                'crypto': '0 8px 32px rgba(0, 0, 0, 0.3)',
                'inner-glow': 'inset 0 2px 4px rgba(255, 255, 255, 0.1)',
            },
            animation: {
                'bounce-slow': 'bounce 2s infinite',
                'pulse-slow': 'pulse 3s infinite',
                'fade-in': 'fadeIn 0.5s ease-in-out',
                'slide-up': 'slideUp 0.3s ease-out',
                'glow': 'glow 2s ease-in-out infinite alternate',
                'float': 'float 3s ease-in-out infinite',
            },
            keyframes: {
                glow: {
                    '0%': { boxShadow: '0 0 20px rgba(79, 70, 229, 0.3)' },
                    '100%': { boxShadow: '0 0 40px rgba(79, 70, 229, 0.6)' },
                },
                float: {
                    '0%, 100%': { transform: 'translateY(0px)' },
                    '50%': { transform: 'translateY(-10px)' },
                },
                fadeIn: {
                    '0%': { opacity: '0' },
                    '100%': { opacity: '1' },
                },
                slideUp: {
                    '0%': { transform: 'translateY(10px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '1' },
                },
            },
            backdropBlur: {
                xs: '2px',
            },
        },
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
    ],
}