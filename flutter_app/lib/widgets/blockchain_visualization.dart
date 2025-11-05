import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated blockchain chain visualization
class BlockchainChainVisualization extends StatefulWidget {
  final int blockCount;
  final bool isActive;

  const BlockchainChainVisualization({
    Key? key,
    this.blockCount = 5,
    this.isActive = true,
  }) : super(key: key);

  @override
  State<BlockchainChainVisualization> createState() => _BlockchainChainVisualizationState();
}

class _BlockchainChainVisualizationState extends State<BlockchainChainVisualization>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _flowController;
  late List<AnimationController> _blockControllers;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _flowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _blockControllers = List.generate(
      widget.blockCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 500 + (index * 100)),
        vsync: this,
      )..forward(),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _flowController.dispose();
    for (var controller in _blockControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomPaint(
        painter: BlockchainChainPainter(
          pulseAnimation: _pulseController,
          flowAnimation: _flowController,
          blockAnimations: _blockControllers.map((c) => c.view).toList(),
          blockCount: widget.blockCount,
          isActive: widget.isActive,
        ),
        child: Container(),
      ),
    );
  }
}

class BlockchainChainPainter extends CustomPainter {
  final Animation<double> pulseAnimation;
  final Animation<double> flowAnimation;
  final List<Animation<double>> blockAnimations;
  final int blockCount;
  final bool isActive;

  BlockchainChainPainter({
    required this.pulseAnimation,
    required this.flowAnimation,
    required this.blockAnimations,
    required this.blockCount,
    required this.isActive,
  }) : super(
          repaint: Listenable.merge([
            pulseAnimation,
            flowAnimation,
            ...blockAnimations,
          ]),
        );

  @override
  void paint(Canvas canvas, Size size) {
    final blockSize = 60.0;
    final spacing = (size.width - (blockCount * blockSize)) / (blockCount + 1);

    for (int i = 0; i < blockCount; i++) {
      final x = spacing + (i * (blockSize + spacing));
      final y = size.height / 2;

      // Draw connecting line with flow animation
      if (i > 0) {
        _drawConnectionLine(
          canvas,
          Offset(x - spacing, y),
          Offset(x, y),
          i,
        );
      }

      // Draw block
      _drawBlock(canvas, Offset(x, y), blockSize, i);
    }
  }

  void _drawConnectionLine(Canvas canvas, Offset start, Offset end, int index) {
    // Main line
    final linePaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, linePaint);

    // Flowing particles
    final particleCount = 3;
    for (int i = 0; i < particleCount; i++) {
      final progress = (flowAnimation.value + (i / particleCount)) % 1.0;
      final particleX = start.dx + (end.dx - start.dx) * progress;
      final particleY = start.dy;

      final particlePaint = Paint()
        ..color = const Color(0xFF00F5FF)
        ..style = PaintingStyle.fill;

      // Glow effect
      canvas.drawCircle(
        Offset(particleX, particleY),
        6,
        Paint()
          ..color = const Color(0xFF00F5FF).withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      canvas.drawCircle(
        Offset(particleX, particleY),
        3,
        particlePaint,
      );
    }
  }

  void _drawBlock(Canvas canvas, Offset center, double size, int index) {
    final animation = blockAnimations[index].value;
    final scale = Curves.elasticOut.transform(animation);

    // Block background with gradient
    final rect = Rect.fromCenter(
      center: center,
      width: size * scale,
      height: size * scale,
    );

    final gradient = LinearGradient(
      colors: [
        const Color(0xFF1a1a2e),
        const Color(0xFF16213e),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final blockPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // Draw block with rounded corners
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, blockPaint);

    // Pulsing border
    final borderPaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.5 + (pulseAnimation.value * 0.5))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, borderPaint);

    // Outer glow
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFF00F5FF).withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Draw block number
    final textPainter = TextPainter(
      text: TextSpan(
        text: '#${index + 1}',
        style: const TextStyle(
          color: Color(0xFF00F5FF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    // Lock icon (simplified)
    _drawLockIcon(canvas, center, size * 0.3);
  }

  void _drawLockIcon(Canvas canvas, Offset center, double size) {
    final lockPaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Lock body
    final bodyRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + size * 0.3),
      width: size * 0.6,
      height: size * 0.5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(4)),
      lockPaint,
    );

    // Lock shackle
    final shacklePath = Path()
      ..moveTo(center.dx - size * 0.2, center.dy + size * 0.05)
      ..lineTo(center.dx - size * 0.2, center.dy - size * 0.1)
      ..arcToPoint(
        Offset(center.dx + size * 0.2, center.dy - size * 0.1),
        radius: Radius.circular(size * 0.2),
        clockwise: false,
      )
      ..lineTo(center.dx + size * 0.2, center.dy + size * 0.05);

    canvas.drawPath(shacklePath, lockPaint);
  }

  @override
  bool shouldRepaint(BlockchainChainPainter oldDelegate) => true;
}

/// Animated transaction flow visualization
class TransactionFlowVisualization extends StatefulWidget {
  final double width;
  final double height;

  const TransactionFlowVisualization({
    Key? key,
    this.width = 400,
    this.height = 300,
  }) : super(key: key);

  @override
  State<TransactionFlowVisualization> createState() => _TransactionFlowVisualizationState();
}

class _TransactionFlowVisualizationState extends State<TransactionFlowVisualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: TransactionFlowPainter(animation: _controller),
      ),
    );
  }
}

class TransactionFlowPainter extends CustomPainter {
  final Animation<double> animation;

  TransactionFlowPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(size.width, size.height) / 3;

    // Draw central node
    _drawNode(canvas, Offset(centerX, centerY), 30, '🏦', 'Bank');

    // Draw orbiting nodes
    final nodeCount = 6;
    for (int i = 0; i < nodeCount; i++) {
      final angle = (animation.value * 2 * math.pi) + (i * 2 * math.pi / nodeCount);
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);

      _drawNode(canvas, Offset(x, y), 20, '👤', 'User');
      _drawConnectionLine(canvas, Offset(centerX, centerY), Offset(x, y), i);
    }
  }

  void _drawNode(Canvas canvas, Offset center, double size, String emoji, String label) {
    // Glow effect
    canvas.drawCircle(
      center,
      size,
      Paint()
        ..color = const Color(0xFF00F5FF).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Node circle
    canvas.drawCircle(
      center,
      size,
      Paint()
        ..color = const Color(0xFF1a1a2e)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      size,
      Paint()
        ..color = const Color(0xFF00F5FF)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Emoji
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: size * 0.8),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawConnectionLine(Canvas canvas, Offset start, Offset end, int index) {
    final paint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(TransactionFlowPainter oldDelegate) => true;
}

/// Blockchain network mesh visualization
class BlockchainNetworkMesh extends StatefulWidget {
  const BlockchainNetworkMesh({Key? key}) : super(key: key);

  @override
  State<BlockchainNetworkMesh> createState() => _BlockchainNetworkMeshState();
}

class _BlockchainNetworkMeshState extends State<BlockchainNetworkMesh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<NetworkNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Generate random nodes
    _nodes = List.generate(20, (index) {
      return NetworkNode(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        vx: (math.Random().nextDouble() - 0.5) * 0.0001,
        vy: (math.Random().nextDouble() - 0.5) * 0.0001,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Update node positions
        for (var node in _nodes) {
          node.x = (node.x + node.vx) % 1.0;
          node.y = (node.y + node.vy) % 1.0;
        }

        return CustomPaint(
          painter: NetworkMeshPainter(nodes: _nodes),
          child: Container(),
        );
      },
    );
  }
}

class NetworkNode {
  double x;
  double y;
  final double vx;
  final double vy;

  NetworkNode({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });
}

class NetworkMeshPainter extends CustomPainter {
  final List<NetworkNode> nodes;

  NetworkMeshPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final distance = math.sqrt(
          math.pow((nodes[i].x - nodes[j].x) * size.width, 2) +
              math.pow((nodes[i].y - nodes[j].y) * size.height, 2),
        );

        if (distance < 150) {
          final paint = Paint()
            ..color = const Color(0xFF00F5FF).withOpacity(0.2 * (1 - distance / 150))
            ..strokeWidth = 1;

          canvas.drawLine(
            Offset(nodes[i].x * size.width, nodes[i].y * size.height),
            Offset(nodes[j].x * size.width, nodes[j].y * size.height),
            paint,
          );
        }
      }
    }

    // Draw nodes
    for (var node in nodes) {
      final center = Offset(node.x * size.width, node.y * size.height);

      // Glow
      canvas.drawCircle(
        center,
        8,
        Paint()
          ..color = const Color(0xFF00F5FF).withOpacity(0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );

      // Node
      canvas.drawCircle(
        center,
        4,
        Paint()
          ..color = const Color(0xFF00F5FF)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(NetworkMeshPainter oldDelegate) => true;
}
