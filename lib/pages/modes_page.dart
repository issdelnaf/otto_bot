import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'manual_control_page.dart';
import 'automatic_page.dart';
import 'mood_based_page.dart';

class ModesPage extends StatefulWidget {
  const ModesPage({super.key});

  @override
  State<ModesPage> createState() => _ModesPageState();
}

class _ModesPageState extends State<ModesPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
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
              child: SafeArea(
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModeButton(
                        'MANUAL',
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ManualControlPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildModeButton(
                        'AUTO',
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AutomaticPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      _buildModeButton(
                        'MOOD',
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MoodBasedPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 306.4,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFFFDFD),
          ),
        ),
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(
              color: Colors.white,
              fontSize: 40,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ),
    );
  }
}
