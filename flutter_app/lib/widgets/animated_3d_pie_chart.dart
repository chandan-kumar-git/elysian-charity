import 'package:flutter/material.dart';
import 'dart:math' as math;

class Animated3DPieChart extends StatefulWidget {
  final List<ChartData> data;
  final double size;

  const Animated3DPieChart({
    Key? key,
    required this.data,
    this.size = 300,
  }) : super(key: key);

  @override
  State<Animated3DPieChart> createState() => _Animated3DPieChartState();
}

class _Animated3DPieChartState extends State<Animated3DPieChart>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _floatController;
  double _dragRotation = 0.0;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragRotation += details.delta.dx * 0.01;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _floatController]),
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.5 + math.sin(_floatController.value * math.pi * 2) * 0.1)
                ..rotateY(_rotationController.value * 2 * math.pi + _dragRotation),
              alignment: Alignment.center,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _3DPieChartPainter(
                  data: widget.data,
                  hoveredIndex: _hoveredIndex,
                  animationValue: _rotationController.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;
  final Color shadowColor;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
    required this.shadowColor,
  });
}

class _3DPieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final int? hoveredIndex;
  final double animationValue;

  _3DPieChartPainter({
    required this.data,
    this.hoveredIndex,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;
    final depth = 30.0;

    // Calculate total
    final total = data.fold(0.0, (sum, item) => sum + item.value);

    double startAngle = -math.pi / 2;

    // Draw 3D slices
    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * math.pi;
      final isHovered = hoveredIndex == i;
      final offset = isHovered ? 10.0 : 0.0;

      // Calculate slice center for offset
      final midAngle = startAngle + sweepAngle / 2;
      final offsetX = math.cos(midAngle) * offset;
      final offsetY = math.sin(midAngle) * offset;

      // Draw shadow layers for 3D depth
      for (int d = 0; d < depth; d++) {
        final shadowPaint = Paint()
          ..color = data[i].shadowColor.withOpacity(0.3 - (d / depth) * 0.2)
          ..style = PaintingStyle.fill;

        final shadowCenter = Offset(
          center.dx + offsetX,
          center.dy + offsetY + d,
        );

        canvas.drawArc(
          Rect.fromCircle(center: shadowCenter, radius: radius),
          startAngle,
          sweepAngle,
          true,
          shadowPaint,
        );
      }

      // Draw top surface with gradient
      final topPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            data[i].color.withOpacity(0.9),
            data[i].color.withOpacity(0.6),
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(center.dx + offsetX, center.dy + offsetY),
          radius: radius,
        ))
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(center.dx + offsetX, center.dy + offsetY),
          radius: radius,
        ),
        startAngle,
        sweepAngle,
        true,
        topPaint,
      );

      // Draw glow effect
      if (isHovered) {
        final glowPaint = Paint()
          ..color = data[i].color.withOpacity(0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

        canvas.drawArc(
          Rect.fromCircle(
            center: Offset(center.dx + offsetX, center.dy + offsetY),
            radius: radius + 10,
          ),
          startAngle,
          sweepAngle,
          true,
          glowPaint,
        );
      }

      // Draw percentage text
      final percentage = ((data[i].value / total) * 100).toStringAsFixed(1);
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$percentage%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.7;
      final textX = center.dx + offsetX + math.cos(textAngle) * textRadius - textPainter.width / 2;
      final textY = center.dy + offsetY + math.sin(textAngle) * textRadius - textPainter.height / 2;

      textPainter.paint(canvas, Offset(textX, textY));

      startAngle += sweepAngle;
    }

    // Draw center highlight
    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.3));

    canvas.drawCircle(center, radius * 0.3, centerPaint);
  }

  @override
  bool shouldRepaint(_3DPieChartPainter oldDelegate) => true;
}
