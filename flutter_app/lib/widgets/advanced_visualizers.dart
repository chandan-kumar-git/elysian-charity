import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

/// Premium 3D Blockchain Network Visualizer
class BlockchainNetworkVisualizer extends StatefulWidget {
  const BlockchainNetworkVisualizer({Key? key}) : super(key: key);

  @override
  State<BlockchainNetworkVisualizer> createState() => _BlockchainNetworkVisualizerState();
}

class _BlockchainNetworkVisualizerState extends State<BlockchainNetworkVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<NetworkNode> _nodes = [];
  final List<Connection> _connections = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _generateNetwork();
  }

  void _generateNetwork() {
    final random = math.Random();
    
    // Create nodes
    for (int i = 0; i < 15; i++) {
      _nodes.add(NetworkNode(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 10 + 5,
        speed: random.nextDouble() * 0.005 + 0.001,
        angle: random.nextDouble() * math.pi * 2,
      ));
    }

    // Create connections
    for (int i = 0; i < _nodes.length; i++) {
      for (int j = i + 1; j < _nodes.length; j++) {
        if (random.nextDouble() > 0.7) {
          _connections.add(Connection(i, j));
        }
      }
    }
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
          node.x += math.cos(node.angle) * node.speed;
          node.y += math.sin(node.angle) * node.speed;

          if (node.x < 0 || node.x > 1) {
            node.angle = math.pi - node.angle;
          }
          if (node.y < 0 || node.y > 1) {
            node.angle = -node.angle;
          }

          node.x = node.x.clamp(0.0, 1.0);
          node.y = node.y.clamp(0.0, 1.0);
        }

        return CustomPaint(
          painter: NetworkPainter(
            nodes: _nodes,
            connections: _connections,
            animation: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class NetworkNode {
  double x;
  double y;
  double size;
  double speed;
  double angle;

  NetworkNode({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class Connection {
  final int nodeA;
  final int nodeB;

  Connection(this.nodeA, this.nodeB);
}

class NetworkPainter extends CustomPainter {
  final List<NetworkNode> nodes;
  final List<Connection> connections;
  final double animation;

  NetworkPainter({
    required this.nodes,
    required this.connections,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections
    for (var connection in connections) {
      final nodeA = nodes[connection.nodeA];
      final nodeB = nodes[connection.nodeB];

      final distance = math.sqrt(
        math.pow((nodeA.x - nodeB.x) * size.width, 2) +
        math.pow((nodeA.y - nodeB.y) * size.height, 2),
      );

      if (distance < 200) {
        final paint = Paint()
          ..color = const Color(0xFF00F5FF).withOpacity(0.3 * (1 - distance / 200))
          ..strokeWidth = 1.5;

        canvas.drawLine(
          Offset(nodeA.x * size.width, nodeA.y * size.height),
          Offset(nodeB.x * size.width, nodeB.y * size.height),
          paint,
        );

        // Animated transaction flow
        final progress = (animation + connection.nodeA / nodes.length) % 1.0;
        final flowX = nodeA.x + (nodeB.x - nodeA.x) * progress;
        final flowY = nodeA.y + (nodeB.y - nodeA.y) * progress;

        canvas.drawCircle(
          Offset(flowX * size.width, flowY * size.height),
          3,
          Paint()
            ..color = const Color(0xFF00FF00).withOpacity(0.8)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }

    // Draw nodes
    for (var node in nodes) {
      final center = Offset(node.x * size.width, node.y * size.height);

      // Outer glow
      canvas.drawCircle(
        center,
        node.size * 2,
        Paint()
          ..color = const Color(0xFFB967FF).withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );

      // Node
      canvas.drawCircle(
        center,
        node.size,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFF00F5FF),
              const Color(0xFFB967FF),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: node.size)),
      );

      // Center dot
      canvas.drawCircle(
        center,
        node.size * 0.3,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(NetworkPainter oldDelegate) => true;
}

/// Holographic Data Stream
class HolographicDataStream extends StatefulWidget {
  const HolographicDataStream({Key? key}) : super(key: key);

  @override
  State<HolographicDataStream> createState() => _HolographicDataStreamState();
}

class _HolographicDataStreamState extends State<HolographicDataStream>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<DataBit> _dataBits = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _generateDataBits();
  }

  void _generateDataBits() {
    final random = math.Random();
    for (int i = 0; i < 40; i++) {
      _dataBits.add(DataBit(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: random.nextDouble() * 0.02 + 0.005,
        char: String.fromCharCode(random.nextInt(26) + 65),
      ));
    }
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
        return CustomPaint(
          painter: DataStreamPainter(
            dataBits: _dataBits,
            animation: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class DataBit {
  double x;
  double y;
  double speed;
  String char;

  DataBit({
    required this.x,
    required this.y,
    required this.speed,
    required this.char,
  });
}

class DataStreamPainter extends CustomPainter {
  final List<DataBit> dataBits;
  final double animation;

  DataStreamPainter({
    required this.dataBits,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var bit in dataBits) {
      bit.y = (bit.y + bit.speed) % 1.0;

      final opacity = (math.sin(animation * math.pi * 2 + bit.x * 10) + 1) / 2;

      textPainter.text = TextSpan(
        text: bit.char,
        style: TextStyle(
          color: const Color(0xFF00F5FF).withOpacity(opacity * 0.5),
          fontSize: 14 + math.sin(animation * math.pi * 2 + bit.y * 10) * 4,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          shadows: [
            Shadow(
              color: const Color(0xFF00F5FF).withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(bit.x * size.width, bit.y * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(DataStreamPainter oldDelegate) => true;
}

/// Animated Stats Counter with Progress Ring
class AnimatedStatsCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;
  final double progress;

  const AnimatedStatsCard({
    Key? key,
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
    this.progress = 0.75,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  tween: Tween(begin: 0, end: progress),
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: CircularProgressPainter(
                        progress: value,
                        color: color,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, color],
            ).createShader(bounds),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..shader = SweepGradient(
          colors: [color, color.withOpacity(0.5)],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
