import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../services/mock_data_service.dart';

class InteractiveDashboard extends StatefulWidget {
  const InteractiveDashboard({Key? key}) : super(key: key);

  @override
  State<InteractiveDashboard> createState() => _InteractiveDashboardState();
}

class _InteractiveDashboardState extends State<InteractiveDashboard>
    with TickerProviderStateMixin {
  final _mockDataService = MockDataService();
  final List<MockTransaction> _transactions = [];
  double _balance = 12.583;
  double _tvl = 125400;
  int _totalDonations = 247;
  int _activeDonors = 89;
  
  StreamSubscription? _transactionSub;
  StreamSubscription? _balanceSub;
  
  late AnimationController _glowController;
  bool _showNewTransactionBadge = false;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Load initial transactions
    _transactions.addAll(_mockDataService.getInitialTransactions());
    
    // Start mock data streams
    _mockDataService.startMockData();
    
    // Listen to new transactions
    _transactionSub = _mockDataService.transactionStream.listen((transaction) {
      setState(() {
        _transactions.insert(0, transaction);
        if (_transactions.length > 10) {
          _transactions.removeLast();
        }
        _showNewTransactionBadge = true;
        _totalDonations++;
        
        // Update TVL
        if (transaction.type == TransactionType.donation) {
          _tvl += transaction.amount * 2500; // Mock ETH price
        }
      });
      
      // Show notification
      _showTransactionNotification(transaction);
      
      // Hide badge after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showNewTransactionBadge = false);
        }
      });
    });
    
    // Listen to balance updates
    _balanceSub = _mockDataService.balanceStream.listen((balance) {
      setState(() => _balance = balance);
    });
  }

  @override
  void dispose() {
    _transactionSub?.cancel();
    _balanceSub?.cancel();
    _mockDataService.stopMockData();
    _glowController.dispose();
    super.dispose();
  }
  
  void _showTransactionNotification(MockTransaction tx) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              tx.type == TransactionType.donation
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: tx.type == TransactionType.donation
                  ? const Color(0xFF10b981)
                  : const Color(0xFFef4444),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tx.type == TransactionType.donation
                        ? 'New Donation Received!'
                        : 'Withdrawal Processed',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${tx.amount.toStringAsFixed(3)} ETH from ${tx.donor}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1a1a2e),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: tx.type == TransactionType.donation
                ? const Color(0xFF10b981)
                : const Color(0xFFef4444),
          ),
        ),
      ),
    );
    
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0f),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            backgroundColor: const Color(0xFF1a1a2e),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Elysium Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7c3aed).withOpacity(0.3),
                      const Color(0xFF1a1a2e),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10b981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF10b981),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Color(0xFF10b981),
                          size: 8,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Color(0xFF10b981),
                            fontSize: 12,
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
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contract Balance Card
                  _buildContractBalanceCard(),
                  
                  const SizedBox(height: 30),
                  
                  // Stats Row
                  _buildStatsRow(),
                  
                  const SizedBox(height: 30),
                  
                  // Recent Transactions
                  _buildRecentTransactions(),
                  
                  const SizedBox(height: 30),
                  
                  // Donation Categories
                  _buildDonationCategories(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDonateModal(context),
        backgroundColor: const Color(0xFF7c3aed),
        icon: const Icon(Icons.volunteer_activism),
        label: const Text(
          'Make Donation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  
  Widget _buildContractBalanceCard() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7c3aed),
                Color(0xFF6366f1),
                Color(0xFF8b5cf6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7c3aed).withOpacity(
                  0.3 + (_glowController.value * 0.2)
                ),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contract Balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10b981).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF10b981)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Color(0xFF10b981),
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'VERIFIED',
                          style: TextStyle(
                            color: Color(0xFF10b981),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _balance.toStringAsFixed(3),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'ETH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '≈ \$${(_balance * 2500).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 25),
              
              // Metrics row
              Row(
                children: [
                  Expanded(child: _buildMetric('24h Volume', '2.3 ETH', Icons.trending_up)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildMetric('APY', '8.5%', Icons.percent)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildMetric('TVL', '\$${(_tvl / 1000).toStringAsFixed(1)}K', Icons.account_balance)),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showDonateModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF7c3aed),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite),
                          SizedBox(width: 8),
                          Text('Donate', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.open_in_new),
                          SizedBox(width: 8),
                          Text('Explorer', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMetric(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Donations', _totalDonations.toString(), Icons.volunteer_activism, const Color(0xFF10b981))),
        const SizedBox(width: 15),
        Expanded(child: _buildStatCard('Active Donors', _activeDonors.toString(), Icons.people, const Color(0xFF3b82f6))),
        const SizedBox(width: 15),
        Expanded(child: _buildStatCard('Countries', '47+', Icons.public, const Color(0xFFf59e0b))),
      ],
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_showNewTransactionBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFef4444),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withOpacity(0.1),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final tx = _transactions[index];
              final isDonation = tx.type == TransactionType.donation;
              
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isDonation
                        ? const Color(0xFF10b981)
                        : const Color(0xFFef4444)
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDonation ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isDonation
                        ? const Color(0xFF10b981)
                        : const Color(0xFFef4444),
                  ),
                ),
                title: Text(
                  isDonation ? 'Donation Received' : 'Withdrawal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${tx.donor} • ${tx.category}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isDonation ? '+' : '-'}${tx.amount.toStringAsFixed(2)} ETH',
                      style: TextStyle(
                        color: isDonation
                            ? const Color(0xFF10b981)
                            : const Color(0xFFef4444),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      tx.timeAgo,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildDonationCategories() {
    final categories = [
      {'name': 'Education', 'icon': Icons.school, 'color': const Color(0xFF3b82f6), 'amount': '45.2K'},
      {'name': 'Healthcare', 'icon': Icons.local_hospital, 'color': const Color(0xFFef4444), 'amount': '38.7K'},
      {'name': 'Environment', 'icon': Icons.eco, 'color': const Color(0xFF10b981), 'amount': '22.1K'},
      {'name': 'Disaster Relief', 'icon': Icons.warning, 'color': const Color(0xFFf59e0b), 'amount': '19.4K'},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Donation Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _showDonateModal(context, category: category['name'] as String),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a2e),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: (category['color'] as Color).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 32,
                      ),
                      const Spacer(),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${category['amount']} raised',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  void _showDonateModal(BuildContext context, {String? category}) {
    // This will be implemented in the next file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Donation modal coming up next!'),
        backgroundColor: Color(0xFF7c3aed),
      ),
    );
  }
}
