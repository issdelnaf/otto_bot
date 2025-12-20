import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AutomaticPage extends StatefulWidget {
  const AutomaticPage({super.key});

  @override
  State<AutomaticPage> createState() => _AutomaticPageState();
}

class _AutomaticPageState extends State<AutomaticPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Color(0xFF4F0C0C)],
                    stops: [0, 0.9],
                    begin: AlignmentDirectional(0, -1),
                    end: AlignmentDirectional(0, 1),
                  ),
                ),
                child: Stack(
                children: [
                  // Animation
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child:
                        ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/Untitled design (9).png',
                                width: 5000,
                                height: 200,
                                fit: BoxFit.cover,
                                alignment: const Alignment(0, 0),
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.red.shade900.withValues(
                                      alpha: 0.3,
                                    ),
                                    child: const Icon(
                                      Icons.directions_run,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  );
                                },
                              ),
                            )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .move(
                              duration: 1670.ms,
                              curve: Curves.linear,
                              begin: const Offset(-49.0, 0.0),
                              end: const Offset(53.0, 0.0),
                            ),
                  ),
                  // Home button
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 24,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
