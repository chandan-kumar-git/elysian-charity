import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../services/advanced_animation_service.dart';
import '../services/realtime_service.dart';

/// Complete crypto wallet with portfolio, transactions, send/receive
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedAsset = 0;
  final RealTimeService _realTimeService = RealTimeService();

  final List<CryptoAsset> _assets = [
    CryptoAsset(
      symbol: 'ETH',
      name: 'Ethereum',
      balance: 2.5847,
      price: 1842.35,
      change24h: 5.47,
      icon: '🔷',
    ),
    CryptoAsset(
      symbol: 'BTC',
      name: 'Bitcoin',
      balance: 0.0234,
      price: 43521.87,
      change24h: -2.13,
      icon: '₿',
    ),
    CryptoAsset(
      symbol: 'USDC',
      name: 'USD Coin',
      balance: 1258.42,
      price: 1.00,
      change24h: 0.01,
      icon: '💵',
    ),
    CryptoAsset(
      symbol: 'MATIC',
      name: 'Polygon',
      balance: 4521.35,
      price: 0.82,
      change24h: 8.92,
      icon: '🟣',
    ),
  ];

  final List<Transaction> _transactions = [
    Transaction(
      type: TransactionType.received,
      amount: 0.5,
      symbol: 'ETH',
      from: '0x742...5e89',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: TransactionStatus.confirmed,
    ),
    Transaction(
      type: TransactionType.sent,
      amount: 0.2,
      symbol: 'ETH',
      to: '0x1a2...9f3c',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: TransactionStatus.confirmed,
    ),
    Transaction(
      type: TransactionType.swap,
      amount: 100,
      symbol: 'USDC',
      swapTo: 'MATIC',
      swapAmount: 122.5,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.confirmed,
    ),
    Transaction(
      type: TransactionType.received,
      amount: 0.01,
      symbol: 'BTC',
      from: '0x8f4...2d1a',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      status: TransactionStatus.pending,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _realTimeService.initialize();
    
    // Listen to price updates
    _realTimeService.priceStream.listen((prices) {
      if (mounted) {
        setState(() {
          for (var asset in _assets) {
            if (prices.containsKey(asset.symbol)) {
              asset.price = prices[asset.symbol]!;
            }
          }
        });
      }
    });
    
    // Listen to new transactions
    _realTimeService.transactionStream.listen((transaction) {
      if (mounted) {
        setState(() {
          _transactions.insert(0, Transaction(
            type: transaction.type == TransactionType.received 
                ? TransactionType.received 
                : TransactionType.sent,
            amount: transaction.amount,
            symbol: transaction.symbol,
            from: transaction.from,
            to: transaction.to,
            timestamp: transaction.timestamp,
            status: transaction.status == TransactionStatus.confirmed
                ? TransactionStatus.confirmed
                : TransactionStatus.pending,
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get totalPortfolioValue {
    return _assets.fold(
        0.0, (sum, asset) => sum + (asset.balance * asset.price));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crypto Wallet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: _showQRScanner,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Portfolio Value Card
          _buildPortfolioCard(),

          // Quick Actions
          _buildQuickActions(),

          // Tabs
          _buildTabBar(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAssetsTab(),
                _buildNFTsTab(),
                _buildActivityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard() {
    return AdvancedAnimationService.shimmer(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7c3aed), Color(0xFF6366f1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7c3aed).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Portfolio Value',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AdvancedAnimationService.countUp(
                  endValue: totalPortfolioValue,
                  duration: const Duration(seconds: 2),
                  prefix: '\$',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                AdvancedAnimationService.pulse(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        const Text(
                          '+12.5%',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          // Mini Chart
          SizedBox(
            height: 60,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 3.5),
                      const FlSpot(3, 5),
                      const FlSpot(4, 4.5),
                      const FlSpot(5, 6),
                    ],
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildActionButton('Send', Icons.arrow_upward, () {
                _showSendDialog();
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton('Receive', Icons.arrow_downward, () {
                _showReceiveDialog();
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton('Swap', Icons.swap_horiz, () {
                _showSwapDialog();
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton('Buy', Icons.add_circle, () {})),
            ],
          ),
          const SizedBox(height: 12),
          // Donate Button
          AdvancedAnimationService.pulse(
            child: GestureDetector(
              onTap: _showDonateDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10b981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10b981).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Donate to Charity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7c3aed), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF7c3aed),
          borderRadius: BorderRadius.circular(16),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        tabs: const [
          Tab(text: 'Assets'),
          Tab(text: 'NFTs'),
          Tab(text: 'Activity'),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildAssetsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        final asset = _assets[index];
        return _buildAssetCard(asset, index);
      },
    );
  }

  Widget _buildAssetCard(CryptoAsset asset, int index) {
    final value = asset.balance * asset.price;
    final isPositive = asset.change24h > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7c3aed).withOpacity(0.3),
                  const Color(0xFF6366f1).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              asset.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${asset.balance.toStringAsFixed(4)} ${asset.symbol}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Value & Change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${asset.change24h.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (400 + index * 100).ms)
        .slideX(begin: 0.2, end: 0, delay: (400 + index * 100).ms);
  }

  Widget _buildNFTsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildNFTCard(index);
      },
    );
  }

  Widget _buildNFTCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NFT Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7c3aed).withOpacity(0.6),
                    Color(0xFF6366f1).withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '🎨',
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),

          // NFT Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Art Piece #${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Floor: ${(0.5 + index * 0.1).toStringAsFixed(2)} ETH',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .scale(begin: const Offset(0.8, 0.8), delay: (index * 100).ms);
  }

  Widget _buildActivityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        return _buildTransactionCard(tx, index);
      },
    );
  }

  Widget _buildTransactionCard(Transaction tx, int index) {
    IconData icon;
    Color color;
    String title;
    String subtitle;

    switch (tx.type) {
      case TransactionType.sent:
        icon = Icons.arrow_upward;
        color = Colors.red;
        title = 'Sent ${tx.symbol}';
        subtitle = 'To ${tx.to}';
        break;
      case TransactionType.received:
        icon = Icons.arrow_downward;
        color = Colors.green;
        title = 'Received ${tx.symbol}';
        subtitle = 'From ${tx.from}';
        break;
      case TransactionType.swap:
        icon = Icons.swap_horiz;
        color = Colors.blue;
        title = 'Swapped ${tx.symbol} → ${tx.swapTo}';
        subtitle = '${tx.amount} → ${tx.swapAmount}';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${tx.type == TransactionType.sent ? '-' : '+'}${tx.amount}',
                style: TextStyle(
                  color: tx.type == TransactionType.sent
                      ? Colors.red
                      : Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: tx.status == TransactionStatus.confirmed
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tx.status == TransactionStatus.confirmed
                      ? 'Confirmed'
                      : 'Pending',
                  style: TextStyle(
                    color: tx.status == TransactionStatus.confirmed
                        ? Colors.green
                        : Colors.orange,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .slideX(begin: -0.2, end: 0, delay: (index * 100).ms);
  }

  void _showQRScanner() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('QR Scanner', style: TextStyle(color: Colors.white)),
        content: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Send Crypto', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Recipient address',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showTransactionSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7c3aed),
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showReceiveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title:
            const Text('Receive Crypto', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('QR CODE', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '0x742d35Cc6634C0532925a3b844Bc9e7595f5e89',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(
                          text:
                              '0x742d35Cc6634C0532925a3b844Bc9e7595f5e89'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Address copied!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7c3aed),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showSwapDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Swap Tokens', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'ETH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '1.0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Icon(Icons.swap_vert, color: Color(0xFF7c3aed), size: 32),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'USDC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '≈ 1,842.35',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showTransactionSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7c3aed),
            ),
            child: const Text('Swap'),
          ),
        ],
      ),
    );
  }

  void _showTransactionSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(duration: 600.ms),
            const SizedBox(height: 20),
            const Text(
              'Transaction Sent!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your transaction is being processed',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7c3aed),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // Donation Dialog with ETH Balance
  void _showDonateDialog() {
    final ethAsset = _assets.firstWhere((asset) => asset.symbol == 'ETH');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10b981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Donate to Charity',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your ETH Balance Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7c3aed), Color(0xFF6366f1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '🔷',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Your ETH Balance',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AdvancedAnimationService.countUp(
                      endValue: ethAsset.balance,
                      duration: const Duration(seconds: 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      suffix: ' ETH',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '≈ \$${(ethAsset.balance * ethAsset.price).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Donation Amounts
              const Text(
                'Quick Donate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDonationChip('0.1 ETH', ethAsset),
                  _buildDonationChip('0.5 ETH', ethAsset),
                  _buildDonationChip('1.0 ETH', ethAsset),
                  _buildDonationChip('Custom', ethAsset, isCustom: true),
                ],
              ),
              const SizedBox(height: 24),

              // Charity Categories
              const Text(
                'Choose Category',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildCharityOption('🌊 Flood Relief', 'Help flood victims'),
              const SizedBox(height: 8),
              _buildCharityOption('🏥 Medical Aid', 'Healthcare support'),
              const SizedBox(height: 8),
              _buildCharityOption('📚 Education', 'Fund schools'),
              const SizedBox(height: 8),
              _buildCharityOption('🌍 Climate Action', 'Environmental causes'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processDonation(ethAsset);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10b981),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Donate Now',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationChip(String label, CryptoAsset asset, {bool isCustom = false}) {
    return GestureDetector(
      onTap: () {
        if (isCustom) {
          // Show custom amount input
          _showCustomDonationInput(asset);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF10b981).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCharityOption(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.3),
            size: 16,
          ),
        ],
      ),
    );
  }

  void _showCustomDonationInput(CryptoAsset asset) {
    // Custom donation amount input dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Custom Donation Amount',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Amount in ETH',
            labelStyle: const TextStyle(color: Colors.white70),
            suffixText: 'ETH',
            suffixStyle: const TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF10b981)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _processDonation(asset);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10b981),
            ),
            child: const Text('Donate'),
          ),
        ],
      ),
    );
  }

  void _processDonation(CryptoAsset asset) {
    // Show confetti and success
    AdvancedAnimationService.showConfetti(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdvancedAnimationService.pulse(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10b981), Color(0xFF059669)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Donation Successful! 🎉',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your donation is helping those in need.\nThank you for making a difference!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction Hash:',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const Icon(Icons.copy, color: Colors.white70, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0x${List.generate(8, (i) => (i * 13 % 16).toRadixString(16)).join()}...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10b981),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class CryptoAsset {
  final String symbol;
  final String name;
  final double balance;
  double price; // Changed to mutable
  final double change24h;
  final String icon;

  CryptoAsset({
    required this.symbol,
    required this.name,
    required this.balance,
    required this.price,
    required this.change24h,
    required this.icon,
  });
}

enum TransactionType { sent, received, swap }

enum TransactionStatus { pending, confirmed, failed }

class Transaction {
  final TransactionType type;
  final double amount;
  final String symbol;
  final String? from;
  final String? to;
  final String? swapTo;
  final double? swapAmount;
  final DateTime timestamp;
  final TransactionStatus status;

  Transaction({
    required this.type,
    required this.amount,
    required this.symbol,
    this.from,
    this.to,
    this.swapTo,
    this.swapAmount,
    required this.timestamp,
    required this.status,
  });
}
