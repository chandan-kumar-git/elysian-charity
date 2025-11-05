import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Marketplace for NFTs and charity items
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'NFTs', 'Charity', 'Collectibles'];

  final List<MarketItem> _items = [
    MarketItem(
      name: 'Charity NFT #001',
      price: 0.5,
      image: '🎨',
      category: 'NFTs',
      seller: 'CharityArt',
      likes: 234,
    ),
    MarketItem(
      name: 'Impact Badge',
      price: 0.1,
      image: '🏅',
      category: 'Collectibles',
      seller: 'ImpactDAO',
      likes: 567,
    ),
    MarketItem(
      name: 'Donation Certificate',
      price: 0.05,
      image: '📜',
      category: 'Charity',
      seller: 'ElysianChain',
      likes: 189,
    ),
    MarketItem(
      name: 'Hero Avatar',
      price: 1.2,
      image: '🦸',
      category: 'NFTs',
      seller: 'MetaCharity',
      likes: 891,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 'All'
        ? _items
        : _items.where((item) => item.category == _selectedCategory).toList();

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
          'Marketplace',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories
          _buildCategories(),

          // Items Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return _buildItemCard(filteredItems[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF0ea5e9), Color(0xFF06b6d4)],
                      )
                    : null,
                color: isSelected ? null : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ).animate().fadeIn(delay: (index * 50).ms);
        },
      ),
    );
  }

  Widget _buildItemCard(MarketItem item, int index) {
    return GestureDetector(
      onTap: () => _showItemDetails(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0ea5e9).withOpacity(0.3),
                      const Color(0xFF06b6d4).withOpacity(0.3),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(item.image, style: const TextStyle(fontSize: 60)),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.favorite, color: Colors.red, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '${item.likes}',
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
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
                    'by ${item.seller}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        '🔷',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.price} ETH',
                        style: const TextStyle(
                          color: Color(0xFF0ea5e9),
                          fontSize: 14,
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
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .scale(begin: const Offset(0.8, 0.8), delay: (index * 100).ms);
  }

  void _showItemDetails(MarketItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a1a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0ea5e9).withOpacity(0.3),
                    const Color(0xFF06b6d4).withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(item.image, style: const TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'by ${item.seller}',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '${item.price} ETH',
                    style: const TextStyle(
                      color: Color(0xFF0ea5e9),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showPurchaseSuccess();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0ea5e9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseSuccess() {
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
              child: const Icon(Icons.check_circle, color: Colors.green, size: 50),
            ).animate().scale(duration: 600.ms),
            const SizedBox(height: 20),
            const Text(
              'Purchase Successful!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Item added to your collection',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0ea5e9)),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class MarketItem {
  final String name;
  final double price;
  final String image;
  final String category;
  final String seller;
  final int likes;

  MarketItem({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.seller,
    required this.likes,
  });
}
