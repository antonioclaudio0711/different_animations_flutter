import 'package:flutter/material.dart';
import 'package:loading_animation/loading_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Loading Animation',
      theme: ThemeData(
        primaryColor: Colors.purple,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animations = List.generate(4, (index) {
      final startInterval = index * 0.2;
      final endInterval = startInterval + 0.5;

      return TweenSequence([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: -30).chain(
            CurveTween(curve: Curves.easeOut),
          ),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: -30, end: 0).chain(
            CurveTween(curve: Curves.easeIn),
          ),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startInterval,
            endInterval.clamp(0.0, 1),
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSquare(Animation<double> animation, Color color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Container(
            width: 20,
            height: 20,
            color: color,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquare(_animations[0], Colors.red),
                const SizedBox(width: 10),
                _buildSquare(_animations[1], Colors.green),
                const SizedBox(width: 10),
                _buildSquare(_animations[2], Colors.blue),
                const SizedBox(width: 10),
                _buildSquare(_animations[3], Colors.yellow),
              ],
            ),
            const SizedBox(height: 50),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingWidget(
                  index: 1,
                  color: Color.fromARGB(255, 158, 111, 167),
                ),
                LoadingWidget(
                  index: 5,
                  color: Color.fromARGB(255, 141, 206, 144),
                ),
                LoadingWidget(
                  index: 10,
                  color: Color.fromARGB(255, 219, 132, 126),
                ),
                LoadingWidget(
                  index: 15,
                  color: Color.fromARGB(255, 223, 177, 110),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
