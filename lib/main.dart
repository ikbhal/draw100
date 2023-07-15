import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(ShapeDrawerApp());

class ShapeDrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shape Drawer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShapeDrawerScreen(),
    );
  }
}

class ShapeDrawerScreen extends StatefulWidget {
  @override
  _ShapeDrawerScreenState createState() => _ShapeDrawerScreenState();
}

class _ShapeDrawerScreenState extends State<ShapeDrawerScreen> {
  List<ShapeModel> shapes = [];
  ShapeModel? selectedShape;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shape Drawer'),
      ),
      body: GestureDetector(
        onTap: () {
          // Deselect the current shape when tapping on the screen.
          setState(() {
            selectedShape = null;
          });
        },
        child: Stack(
          children: [
            CustomPaint(
              painter: ShapePainter(shapes),
              child: Container(),
            ),
            ...shapes.map((shape) {
              return Positioned(
                left: shape.position.dx,
                top: shape.position.dy,
                child: GestureDetector(
                  onTap: () {
                    // Select the shape when tapping on it.
                    setState(() {
                      selectedShape = shape;
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: shape.size.width,
                        height: shape.size.height,
                        decoration: BoxDecoration(
                          color: shape.color,
                          border: Border.all(
                            color: selectedShape == shape
                                ? Colors.white
                                : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                      ),
                      if (selectedShape == shape)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Remove the selected shape when the delete icon is tapped.
                              setState(() {
                                shapes.remove(shape);
                                selectedShape = null;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add a new shape at a random position and with a random color.
          setState(() {
            final random = Random();
            final position = Offset(
              random.nextDouble() * MediaQuery.of(context).size.width,
              random.nextDouble() * MediaQuery.of(context).size.height,
            );
            final size = Size(100, 100);
            final color = Color.fromRGBO(
              random.nextInt(256),
              random.nextInt(256),
              random.nextInt(256),
              1,
            );
            shapes.add(ShapeModel(position: position, size: size, color: color));
          });
        },
      ),
    );
  }
}

class ShapeModel {
  final Offset position;
  final Size size;
  final Color color;

  ShapeModel({required this.position, required this.size, required this.color});
}

class ShapePainter extends CustomPainter {
  final List<ShapeModel> shapes;

  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final rect = Rect.fromLTWH(
        shape.position.dx,
        shape.position.dy,
        shape.size.width,
        shape.size.height,
      );
      final paint = Paint()..color = shape.color;
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
