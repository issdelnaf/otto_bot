import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bluetooth_service.dart';
import 'scan_page.dart';
import 'manual_control_page.dart';
import 'automatic_page.dart';
import 'mood_based_page.dart';

class ModesPage extends StatefulWidget {
  const ModesPage({super.key});

  @override
  State<ModesPage> createState() => _ModesPageState();
}

class _ModesPageState extends State<ModesPage> {
  final OttoBluetoothService _bluetoothService = OttoBluetoothService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFF4F0C0C)],
              stops: [0, 1],
              begin: AlignmentDirectional(0, -1),
              end: AlignmentDirectional(0, 1),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // CENTER CONTENT
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModeButton('MANUAL', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ManualControlPage(),
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                      _buildModeButton('AUTO', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AutomaticPage(),
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                      _buildModeButton('MOOD', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MoodBasedPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // BOTTOM-CENTER BLUETOOTH BUTTON
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IconButton(
                      icon: const Icon(Icons.bluetooth, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fixedSize: const Size(56, 56),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ScanPage(),
                          ),
                        );

                        await _bluetoothService.disconnect();
                      },
                    ),
                  ),
                ),
              ],
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
          border: Border.all(color: const Color(0xFFFFFDFD)),
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
