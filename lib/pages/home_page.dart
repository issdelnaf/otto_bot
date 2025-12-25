import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // splash screen remove - timed with page slide-in
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      FlutterNativeSplash.remove();
    });

    // Navigate to Scan page
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 5000));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            opaque: true,
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ScanPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // fade transition
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body:
            SafeArea(
              child: Container(
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
                              right: 9,
                              child:
                                  ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/ottologo -Photoroom.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade900,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                                        delay: 800.ms,
                                        duration: 2800.ms,
                                        curve: Curves.easeInOut,
                                        begin: const Offset(0, -100),
                                        end: Offset.zero,
                                      )
                                      .fade(
                                        duration: 100.ms,
                                        //delay: 800.ms,
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
            ).animate().slideY(
              begin: 1.0,
              end: 0.0,
              duration: 1500.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}
