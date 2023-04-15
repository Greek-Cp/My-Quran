import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  static String routeName = "/uji";
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    // Define the opacity animation
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Define the position animation
    _positionAnimation = Tween<Offset>(
      begin: Offset(-1, -0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    // Don't forget to dispose the AnimationController when it's no longer needed
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    // Check the status of the AnimationController and start/stop the animation accordingly
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Widget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Wrap the widget in a FadeTransition to apply the opacity animation
            FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                // Use the position animation to animate the position of the widget
                position: _positionAnimation,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _animate,
              child: Text('Animate'),
            ),
          ],
        ),
      ),
    );
  }
}
