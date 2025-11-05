import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeatureInfoModal extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final String description;
  final List<String> keyPoints;
  final String technicalDetails;

  const FeatureInfoModal({
    Key? key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.description,
    required this.keyPoints,
    required this.technicalDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              const Color(0xFF1A1F3A),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: gradient[0].withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Key Points
                    const Text(
                      'Key Features',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...keyPoints.map((point) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: gradient),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  point,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(height: 32),

                    // Technical Details
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: gradient[0].withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.code,
                                color: gradient[0],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Technical Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            technicalDetails,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer CTA
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.article, color: Colors.white),
                    label: const Text(
                      'Read Documentation',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/dashboard');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gradient[0],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try It Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
    );
  }
}

class FeatureInfo {
  static const Map<String, Map<String, dynamic>> features = {
    'Lightning Fast': {
      'description':
          'Experience unprecedented transaction speeds with our advanced blockchain architecture. Elysian Chain processes thousands of transactions per second with near-instant finality, making it one of the fastest blockchain networks in existence. Our innovative consensus mechanism eliminates the traditional bottlenecks found in older blockchain systems, delivering a seamless user experience that rivals centralized payment processors. Whether you\'re sending tokens, executing smart contracts, or participating in DeFi protocols, every action completes in milliseconds, not minutes.',
      'keyPoints': [
        'Process over 50,000 transactions per second (TPS) with horizontal scaling',
        'Sub-second block finality ensures instant confirmation',
        'Optimized virtual machine (EVM) for 10x faster smart contract execution',
        'Parallel transaction processing eliminates network congestion',
        'Advanced mempool management prioritizes high-value transactions',
      ],
      'technicalDetails':
          'Elysian Chain utilizes a hybrid Proof-of-Stake (PoS) consensus with Byzantine Fault Tolerance (BFT), combined with sharding technology to achieve massive throughput. Our custom-built Elysian Virtual Machine (EVM) is fully compatible with Ethereum smart contracts while offering significant performance improvements through Just-In-Time (JIT) compilation and state caching.',
    },
    'Bank-Grade Security': {
      'description':
          'Security is not just a feature—it\'s the foundation of everything we build. Elysian Chain implements multiple layers of security protocols, from cryptographic standards to smart contract auditing, ensuring your assets are protected against all known attack vectors. Our network has undergone rigorous security audits by leading blockchain security firms and maintains a bug bounty program to continuously improve our defenses. With advanced encryption, multi-signature support, and real-time threat detection, we provide institutional-grade security for everyone.',
      'keyPoints': [
        'Military-grade encryption (AES-256) protects all transactions and data',
        'Multi-signature wallet support for enhanced account security',
        'Regular security audits by Certik, Quantstamp, and Trail of Bits',
        'Real-time anomaly detection prevents suspicious activities',
        'Cold storage integration for long-term asset protection',
        'Zero-knowledge proofs for private transactions',
      ],
      'technicalDetails':
          'Our security architecture employs elliptic curve cryptography (secp256k1) for digital signatures, combined with SHA-3 hashing for data integrity. Smart contracts deployed on Elysian Chain undergo mandatory automated security scans using static analysis tools, and critical contracts require formal verification before deployment.',
    },
    'DeFi Ready': {
      'description':
          'Elysian Chain is purpose-built for decentralized finance, offering native support for all major DeFi primitives. From automated market makers (AMMs) to lending protocols and yield farming, our platform provides the infrastructure and tools developers need to build next-generation financial applications. With built-in liquidity pools, oracle integration, and governance frameworks, launching a DeFi project on Elysian is faster and more cost-effective than ever. Our extensive DeFi toolkit includes ready-to-use smart contract templates, comprehensive documentation, and developer grants to accelerate innovation.',
      'keyPoints': [
        'Native DEX support with optimal swap routing and minimal slippage',
        'Integrated lending and borrowing protocols with competitive APYs',
        'Yield farming aggregators maximize returns automatically',
        'Built-in oracle network (Chainlink-compatible) for price feeds',
        'Liquidity mining incentives for early adopters',
        'Cross-chain asset bridges connect to major DeFi ecosystems',
      ],
      'technicalDetails':
          'Elysian\'s DeFi stack includes ERC-20 token standards, automated market maker (AMM) contracts using the constant product formula (x*y=k), and flash loan capabilities for advanced trading strategies. Our composable DeFi modules allow developers to mix and match features to create unique financial products.',
    },
    'Low Fees': {
      'description':
          'High transaction fees shouldn\'t prevent you from using blockchain technology. Elysian Chain has revolutionized gas economics, reducing transaction costs by up to 99% compared to traditional networks like Ethereum mainnet. Our efficient design means you can send tokens, interact with smart contracts, and participate in DeFi for pennies instead of dollars. Whether you\'re making micro-payments or complex multi-step transactions, our fee structure remains affordable and predictable. Dynamic fee adjustment ensures optimal pricing during high and low network activity periods.',
      'keyPoints': [
        'Average transaction cost: \$0.01-\$0.05 (vs \$20-\$100 on Ethereum)',
        'Gas tokens can be paid in any major cryptocurrency',
        'Fee delegation allows dApps to sponsor user transactions',
        'Predictable fee estimation prevents costly surprises',
        'Batch transactions reduce costs for multiple operations',
        'Fee rebate program rewards active network participants',
      ],
      'technicalDetails':
          'Our fee model uses EIP-1559-style base fees with burn mechanisms to maintain deflationary tokenomics. The Elysian gas price oracle dynamically adjusts fees based on network congestion using a weighted moving average algorithm, ensuring fair pricing for all users. Smart contracts are optimized at the bytecode level to minimize gas consumption.',
    },
    'Cross-Chain': {
      'description':
          'In a multi-chain future, interoperability is essential. Elysian Chain\'s cross-chain infrastructure enables seamless asset transfers and communication between different blockchain networks. Our trustless bridge technology connects Ethereum, Binance Smart Chain, Polygon, Avalanche, and more, allowing you to move assets freely without centralized intermediaries. Whether you\'re arbitraging across DEXs, consolidating assets, or accessing unique opportunities on other chains, our cross-chain bridges make it simple and secure. With support for wrapped tokens and atomic swaps, the possibilities are endless.',
      'keyPoints': [
        'Bridge assets to/from Ethereum, BSC, Polygon, Avalanche, Solana',
        'Trustless cross-chain swaps using hash time-locked contracts (HTLCs)',
        'Wrapped token standards (wETH, wBTC) with 1:1 peg guarantee',
        'Cross-chain messaging protocol for smart contract interactions',
        'Liquidity aggregation from multiple chains for best prices',
        'Inter-Blockchain Communication (IBC) protocol support',
      ],
      'technicalDetails':
          'Elysian bridges utilize a validator network with economic incentives to secure cross-chain transfers. Our implementation supports both lock-and-mint and burn-and-mint mechanisms, with cryptographic proofs verified by on-chain smart contracts. The bridge infrastructure includes fraud-proof systems and dispute resolution to prevent malicious activities.',
    },
    'Eco-Friendly': {
      'description':
          'Blockchain shouldn\'t cost the Earth. While older Proof-of-Work networks consume as much energy as entire countries, Elysian Chain\'s Proof-of-Stake consensus uses 99.9% less energy. Our validators run on energy-efficient hardware, and many choose renewable energy sources, making Elysian one of the most environmentally sustainable blockchain platforms. By eliminating energy-intensive mining, we achieve consensus through economic incentives rather than computational waste. This eco-conscious approach doesn\'t compromise security or decentralization—it enhances them while protecting our planet for future generations.',
      'keyPoints': [
        'Proof-of-Stake consensus eliminates energy-intensive mining',
        'Carbon-neutral network through renewable energy partnerships',
        'Energy consumption: 0.01 kWh per transaction (vs 150 kWh for Bitcoin)',
        'Validator incentives encourage green hosting providers',
        'Transparent sustainability reporting and carbon offset programs',
        'Partnership with Climate Chain Coalition for environmental initiatives',
      ],
      'technicalDetails':
          'Elysian\'s PoS implementation requires validators to stake tokens rather than solve computational puzzles, reducing energy consumption by over 99.9%. Our consensus algorithm uses a Practical Byzantine Fault Tolerance (PBFT) variant that achieves finality in 2-3 seconds with minimal computational overhead. The network tracks energy usage metrics on-chain for full transparency.',
    },
  };
}
