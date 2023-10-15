import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WaveAppBarNavigator(),
    );
  }
}

class WaveAppBarNavigator extends StatefulWidget {
  @override
  _WaveAppBarNavigatorState createState() => _WaveAppBarNavigatorState();
}

class _WaveAppBarNavigatorState extends State<WaveAppBarNavigator>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _waveController;
  late Animation<double> _floatingButtonAnimation;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _floatingButtonAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_waveController);

    _waveController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return CustomPaint(
              painter: WavePainter(_waveController.value),
              child: AppBar(
                title: Text(" App Bar"),
                backgroundColor: Colors.transparent,
              ),
            );
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'Home',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'Search',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, _) {
              return CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 80),
                painter: _WavyPainter(_waveController.value),
              );
            },
          ),
          Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
              currentIndex: _currentIndex,
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: 95,
            child: AnimatedBuilder(
              animation: _floatingButtonAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    -20 * sin(_floatingButtonAnimation.value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }
}

class _WavyPainter extends CustomPainter {
  final double waveProgress;

  _WavyPainter(this.waveProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent;

    final path = Path();
    path.lineTo(0, size.height);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(i, sin((i / size.width + waveProgress) * 3 * pi) * 12 + -15);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavyPainter oldDelegate) => true;
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * (1.0 - animationValue));

    for (var i = 0; i <= size.width; i++) {
      double x = i.toDouble();
      double y = size.height * (1.0 - animationValue) +
          10 * sin((x / size.width * 2 * pi) + (2 * pi * animationValue));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height * (1.0 - animationValue));
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
