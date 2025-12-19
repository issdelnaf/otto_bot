import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Navigate to Modes page after 5 seconds
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 5000));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ModesPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 2000),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  stops: [0, 1],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // OTTO BOT text and logo
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'OTTO',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.pressStart2p(
                                color: Colors.white,
                                fontSize: 60,
                                letterSpacing: 0.0,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'BOT',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.pressStart2p(
                                color: Colors.white,
                                fontSize: 60,
                                letterSpacing: 0.0,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                        // Logo position
                        Positioned(
                          top: -45,
                          right: 10,
                          child:
                              ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/ottologo -Photoroom.png',
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.smart_toy,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                    ),
                                  )
                                  .animate()
                                  .move(
                                    duration: 1000.ms,
                                    curve: Curves.easeInOut,
                                    begin: const Offset(0, -100),
                                    end: Offset.zero,
                                  )
                                  .fade(
                                    duration: 1000.ms,
                                    delay: 600.ms,
                                    curve: Curves.easeInOut,
                                    begin: 0.41,
                                    end: 1.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
