import 'package:flutter/material.dart';
import 'dart:math' as math;

class Interactive3DCards extends StatelessWidget {
  const Interactive3DCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
      child: Column(
        children: [
          Text(
            'Make an Impact',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose a cause that matters to you',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _Card3D(
                icon: Icons.school,
                title: 'Education',
                amount: '\$124,500',
                donors: '2,341',
                color: Color(0xFF00D9FF),
              ),
              _Card3D(
                icon: Icons.local_hospital,
                title: 'Healthcare',
                amount: '\$98,200',
                donors: '1,876',
                color: Color(0xFFFF006E),
              ),
              _Card3D(
                icon: Icons.water_drop,
                title: 'Clean Water',
                amount: '\$156,800',
                donors: '3,124',
                color: Color(0xFF00FF88),
              ),
              _Card3D(
                icon: Icons.volunteer_activism,
                title: 'Relief',
                amount: '\$87,300',
                donors: '1,432',
                color: Color(0xFFFFBD00),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card3D extends StatefulWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String donors;
  final Color color;

  const _Card3D({
    required this.icon,
    required this.title,
    required this.amount,
    required this.donors,
    required this.color,
  });

  @override
  State<_Card3D> createState() => _Card3DState();
}

class _Card3DState extends State<_Card3D> {
  double _rotationX = 0;
  double _rotationY = 0;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _rotationX = 0;
          _rotationY = 0;
        });
      },
      onHover: (event) {
        final size = context.size;
        if (size != null) {
          final x = (event.localPosition.dx - size.width / 2) / size.width;
          final y = (event.localPosition.dy - size.height / 2) / size.height;
          setState(() {
            _rotationY = x * 0.3;
            _rotationX = -y * 0.3;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_rotationX)
          ..rotateY(_rotationY)
          ..scale(_isHovered ? 1.05 : 1.0),
        child: Container(
          width: 280,
          height: 320,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withOpacity(0.3),
                widget.color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.color.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 30 : 20,
                spreadRadius: _isHovered ? 5 : 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.color, widget.color.withOpacity(0.6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Raised',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.amount,
                          style: TextStyle(
                            color: widget.color,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Donors',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.donors,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Donate Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
