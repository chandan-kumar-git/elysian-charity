import 'package:flutter/material.dart';

class FloatingActionDonateButton extends StatefulWidget {
  final VoidCallback onPressed;

  const FloatingActionDonateButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<FloatingActionDonateButton> createState() => _FloatingActionDonateButtonState();
}

class _FloatingActionDonateButtonState extends State<FloatingActionDonateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isExpanded = true;
        _controller.forward();
      }),
      onExit: (_) => setState(() {
        _isExpanded = false;
        _controller.reverse();
      }),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: 60,
            padding: EdgeInsets.symmetric(
              horizontal: 16 + (_controller.value * 16),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7B3FF2),
                  Color(0xFFB65FFF),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B3FF2).withOpacity(0.5 + _controller.value * 0.3),
                  blurRadius: 20 + (_controller.value * 10),
                  spreadRadius: 5 + (_controller.value * 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 28,
                    ),
                    if (_isExpanded) ...[
                      const SizedBox(width: 12),
                      const Text(
                        'Donate Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
