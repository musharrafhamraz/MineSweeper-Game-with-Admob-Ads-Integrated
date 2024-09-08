import 'package:flutter/material.dart';

class PlusTwoAnimation extends StatefulWidget {
  const PlusTwoAnimation({super.key});

  @override
  __PlusTwoAnimationState createState() => __PlusTwoAnimationState();
}

class __PlusTwoAnimationState extends State<PlusTwoAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _positionAnimation;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOut,
      ),
    );

    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -8),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeOut,
      ),
    );

    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _positionAnimation!,
      child: FadeTransition(
        opacity: _opacityAnimation!,
        child: ScaleTransition(
          scale: _scaleAnimation!,
          child: const SizedBox(
            width: 40, // Match the size of the button
            height: 40, // Match the size of the button
            child: Center(
              child: Text(
                '+2',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
