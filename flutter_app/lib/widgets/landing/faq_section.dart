import 'package:flutter/material.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({Key? key}) : super(key: key);

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int? _expandedIndex;

  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How does blockchain ensure transparency?',
      answer: 'Every transaction is recorded on the Ethereum blockchain, creating an immutable and publicly verifiable record. You can track your donation from your wallet to the final recipient.',
    ),
    FAQItem(
      question: 'Are there any fees?',
      answer: 'We charge zero platform fees! 100% of your donation goes to the cause. You only pay the minimal blockchain gas fees required to process the transaction.',
    ),
    FAQItem(
      question: 'How do I get started?',
      answer: 'Simply connect your Web3 wallet (MetaMask, WalletConnect, etc.), choose a cause, and donate. You\'ll receive instant confirmation and can track your impact in real-time.',
    ),
    FAQItem(
      question: 'Is my donation tax-deductible?',
      answer: 'Yes! We\'re a registered 501(c)(3) non-profit organization. You\'ll receive a tax receipt for all donations made through our platform.',
    ),
    FAQItem(
      question: 'Can I donate with traditional currency?',
      answer: 'Currently, we accept cryptocurrency donations (ETH, USDC, DAI). We\'re working on adding traditional payment methods soon!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
      child: Column(
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: List.generate(
                _faqs.length,
                (index) => _buildFAQItem(_faqs[index], index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq, int index) {
    final isExpanded = _expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(isExpanded ? 0.1 : 0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded 
              ? Color(0xFF7B3FF2).withOpacity(0.5) 
              : Colors.white.withOpacity(0.1),
          width: isExpanded ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          title: Text(
            faq.question,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
            color: Color(0xFF7B3FF2),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedIndex = expanded ? index : null;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                faq.answer,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
