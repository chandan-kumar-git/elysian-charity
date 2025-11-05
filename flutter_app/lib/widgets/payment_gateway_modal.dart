import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/fiat_payment_service.dart';

/// Mock Payment Gateway Widget - Looks like real Stripe/PayPal checkout
/// Shows realistic payment form for demo purposes
class PaymentGatewayModal extends StatefulWidget {
  final double amount;
  final String campaignName;
  final String campaignId;

  const PaymentGatewayModal({
    Key? key,
    required this.amount,
    required this.campaignName,
    required this.campaignId,
  }) : super(key: key);

  @override
  State<PaymentGatewayModal> createState() => _PaymentGatewayModalState();
}

class _PaymentGatewayModalState extends State<PaymentGatewayModal> {
  final _fiatService = FiatPaymentService();
  String _selectedMethod = 'credit_card';
  bool _processing = false;
  bool _success = false;
  String? _txHash;

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    setState(() {
      _processing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    // Simulate success
    final result = await _fiatService.processCreditCardPayment(
      amountUSD: widget.amount,
      campaignId: widget.campaignId,
      donorEmail: _emailController.text.isEmpty ? 'donor@example.com' : _emailController.text,
      donorName: _nameController.text.isEmpty ? 'Anonymous' : _nameController.text,
      cardDetails: {
        'number': _cardNumberController.text,
        'expiry': _expiryController.text,
        'cvv': _cvvController.text,
      },
    );

    setState(() {
      _processing = false;
      _success = result['success'] ?? false;
      _txHash = result['txHash'];
    });

    if (_success) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_success) {
      return _buildSuccessView();
    }

    if (_processing) {
      return _buildProcessingView();
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a2e).withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF00F5FF).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildPaymentMethodSelector(),
                    const SizedBox(height: 24),
                    _buildPaymentForm(),
                    const SizedBox(height: 24),
                    _buildAmountSummary(),
                    const SizedBox(height: 24),
                    _buildPayButton(),
                    const SizedBox(height: 16),
                    _buildSecurityBadges(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00F5FF), Color(0xFFB967FF)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.payment, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Secure Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Donating to ${widget.campaignName}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    final methods = _fiatService.getPaymentMethods().take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: methods.map((method) {
            final isSelected = _selectedMethod == method['id'];
            return InkWell(
              onTap: () => setState(() => _selectedMethod = method['id']),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00F5FF).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF00F5FF)
                        : Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(method['icon'], style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      method['name'],
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF00F5FF) : Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Card Number',
          controller: _cardNumberController,
          hint: '4242 4242 4242 4242',
          icon: Icons.credit_card,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Expiry',
                controller: _expiryController,
                hint: 'MM/YY',
                icon: Icons.date_range,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'CVV',
                controller: _cvvController,
                hint: '123',
                icon: Icons.lock,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Name on Card',
          controller: _nameController,
          hint: 'John Doe',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Email',
          controller: _emailController,
          hint: 'your@email.com',
          icon: Icons.email,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              prefixIcon: Icon(icon, color: const Color(0xFF00F5FF), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSummary() {
    final breakdown = _fiatService.calculatePaymentBreakdown(
      amountUSD: widget.amount,
      paymentMethod: _selectedMethod,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00FF00).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Your Donation', '\$${widget.amount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Processing Fee (${breakdown['feePercentage']}%)',
            '-\$${breakdown['fee'].toStringAsFixed(2)}',
            isNegative: true,
          ),
          const Divider(color: Colors.white24, height: 24),
          _buildSummaryRow(
            'To Charity',
            '\$${breakdown['netAmount'].toStringAsFixed(2)}',
            isBold: true,
            color: const Color(0xFF00FF00),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Converted to ETH',
            '${breakdown['cryptoAmount'].toStringAsFixed(6)} ETH',
            color: const Color(0xFF00F5FF),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isNegative = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? (isNegative ? Colors.red : Colors.white),
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00F5FF),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, color: Colors.black, size: 20),
            const SizedBox(width: 8),
            Text(
              'Donate \$${widget.amount.toStringAsFixed(2)} Now',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBadge(Icons.verified_user, 'SSL Secure'),
        const SizedBox(width: 16),
        _buildBadge(Icons.link, 'Blockchain'),
        const SizedBox(width: 16),
        _buildBadge(Icons.check_circle, 'PCI Compliant'),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00FF00), size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e).withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00F5FF).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F5FF)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Processing Payment...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Converting \$${widget.amount.toStringAsFixed(2)} to ETH',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sending to smart contract...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e).withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00FF00).withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF00FF00), Color(0xFF00F5FF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF00).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Donation Successful!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$${widget.amount.toStringAsFixed(2)} donated to ${widget.campaignName}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
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
                    children: [
                      const Icon(Icons.link, color: Color(0xFF00F5FF), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Blockchain TX:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _txHash ?? '0x123abc...',
                    style: const TextStyle(
                      color: Color(0xFF00F5FF),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'View on Etherscan →',
              style: TextStyle(
                color: const Color(0xFF00F5FF).withOpacity(0.8),
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
