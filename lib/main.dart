import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

enum Face { front, back }

extension on Face {
  String get text {
    switch (this) {
      case Face.front:
        return 'Front';
      case Face.back:
        return 'Back';
    }
  }

  String get key => text;

  AssetImage get image {
    switch (this) {
      case Face.front:
        return const AssetImage('images/front.png');
      case Face.back:
        return const AssetImage('images/back.png');
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CardWidget frontWidget;
  late final CardWidget backWidget;

  bool _isShowingFront = true;

  @override
  void initState() {
    super.initState();
    frontWidget = CardWidget(
      key: ValueKey(Face.front.key),
      face: Face.front,
      onTapped: () => setState(() => _isShowingFront = false),
    );
    backWidget = CardWidget(
      key: ValueKey(Face.back.key),
      face: Face.back,
      onTapped: () => setState(() => _isShowingFront = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
      ),
      body: switcherWidget(),
    );
  }

  Widget switcherWidget() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: _isShowingFront ? 0.0 : pi),
      duration: const Duration(seconds: 1),
      curve: Curves.linearToEaseOut,
      builder: (context, value, child) {
        final isShowingBack = value > pi / 2;
        final toDisplay = isShowingBack ? backWidget : frontWidget;
        return Transform(
          transform: Matrix4.identity()
            ..scale(0.7, 0.7)
            ..rotateY(value),
          alignment: Alignment.center,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isShowingBack ? pi : 0.0),
            child: toDisplay,
          ),
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final Face face;
  final VoidCallback onTapped;
  const CardWidget({super.key, required this.face, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[300],
            border: Border.all(
              width: 2,
              color: Colors.white,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 50,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: face.image,
                ),
                Text(
                  face.text,
                  style: TextStyle(
                    fontSize: 90,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 3),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
