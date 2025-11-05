import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Real3DMustang extends StatefulWidget {
  final double size;

  const Real3DMustang({
    Key? key,
    this.size = 200,
  }) : super(key: key);

  @override
  State<Real3DMustang> createState() => _Real3DMustangState();
}

class _Real3DMustangState extends State<Real3DMustang>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Object? mustang;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _loadMustang();
  }

  Future<void> _loadMustang() async {
    try {
      mustang = Object(
        fileName: 'assets/models/Mustang 13.04.2021 Compressed.obj',
        scale: Vector3(widget.size / 150, widget.size / 150, widget.size / 150),
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading Mustang model: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F5FF)),
          ),
        ),
      );
    }

    if (mustang == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: Icon(Icons.error, color: Colors.red),
        ),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Rotate the Mustang continuously
          mustang!.rotation.y = _controller.value * 360;
          // Slight tilt for better view
          mustang!.rotation.x = -15;
          // Add subtle bounce effect
          mustang!.rotation.z = 5;

          return Cube(
            onSceneCreated: (Scene scene) {
              scene.world.add(mustang!);
              scene.camera.zoom = 12;
            },
          );
        },
      ),
    );
  }
}
