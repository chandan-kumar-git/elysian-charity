/** @type {import('next').NextConfig} */
const nextConfig = {
    typescript: {
        // Allow production builds to complete even if there are type errors
        ignoreBuildErrors: false,
    },
    eslint: {
        // Allow production builds to complete even if there are ESLint errors
        ignoreDuringBuilds: false,
    },
    env: {
        NEXT_PUBLIC_APP_NAME: 'Elysian Charity',
        NEXT_PUBLIC_APP_DESCRIPTION: 'Transparent Charity Donation System',
    },
}

module.exports = nextConfig