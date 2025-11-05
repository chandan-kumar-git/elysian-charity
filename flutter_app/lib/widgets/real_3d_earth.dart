import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Real3DEarth extends StatefulWidget {
  final double size;
  
  const Real3DEarth({
    Key? key,
    this.size = 200,
  }) : super(key: key);

  @override
  State<Real3DEarth> createState() => _Real3DEarthState();
}

class _Real3DEarthState extends State<Real3DEarth>
    with SingleTickerProviderStateMixin {
  late Object earth;
  late AnimationController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    _loadEarthModel();
  }

  Future<void> _loadEarthModel() async {
    try {
      earth = Object(
        fileName: 'assets/models/earth.obj',
        scale: Vector3(widget.size / 100, widget.size / 100, widget.size / 100),
      );
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Earth model: $e');
      setState(() {
        _isLoading = false;
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
    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00F5FF),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          earth.rotation.y = _controller.value * 360;
          earth.rotation.x = 23.5; // Earth's tilt
          
          return Cube(
            onSceneCreated: (Scene scene) {
              scene.world.add(earth);
              scene.camera.zoom = 10;
            },
          );
        },
      ),
    );
  }
}
