import 'package:flutter/material.dart';

import 'homepage.dart';

class Promt extends StatefulWidget {
  const Promt({super.key});

  @override
  State<Promt> createState() => _PromtState();
}

class _PromtState extends State<Promt> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 35, 35),
      body: Center(
        child: animatedPrompt(
            title: "Success!!!",
            subtitle: "Your post have been posted successfully.",
            child: Icon(
              Icons.check,
              color: Colors.white,
            )),
      ),
    );
  }
}

class animatedPrompt extends StatefulWidget {
  const animatedPrompt(
      {super.key,
      required this.title,
      required this.child,
      required this.subtitle});
  final String title;
  final String subtitle;
  final Widget child;
  @override
  State<animatedPrompt> createState() => _animatedPromptState();
}

class _animatedPromptState extends State<animatedPrompt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _yAnimation;
  late Animation<double> _iconAnimation, containerAnimation, sequenceAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _iconAnimation = Tween<double>(begin: 7, end: 6)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    containerAnimation =
        Tween<double>(begin: 2, end: 0.4).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
    _yAnimation = Tween<Offset>(
            begin: const Offset(0, 0), end: const Offset(0, -0.23))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    sequenceAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30, end: 50), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50, end: 30), weight: 50)
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller
      ..reset()
      ..forward();
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minWidth: 100,
            maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Positioned.fill(
                child: SlideTransition(
              position: _yAnimation,
              child: ScaleTransition(
                scale: containerAnimation,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: ScaleTransition(
                      scale: _iconAnimation,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
