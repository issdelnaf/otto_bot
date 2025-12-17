import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modes_page.dart';
import '../services/bluetooth_service.dart';

class ManualControlPage extends StatefulWidget {
  const ManualControlPage({super.key});

  @override
  State<ManualControlPage> createState() => _ManualControlPageState();
}

class _ManualControlPageState extends State<ManualControlPage> {
  final BluetoothService _bluetoothService = BluetoothService();

  // Send command via Bluetooth
  Future<void> _sendCommand(String command) async {
    bool success = await _bluetoothService.sendCommand(command);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send command: $command'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
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
                    stops: [0, 1],
                    begin: AlignmentDirectional(0, -1),
                    end: AlignmentDirectional(0, 1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Home button
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ModesPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // MOVE! title
                    Text(
                      'MOVE!',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 24,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Arrow icon buttons
                    _buildArrowButton(Icons.keyboard_double_arrow_up_rounded, 'FORWARD'),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildArrowButton(Icons.keyboard_double_arrow_left_rounded, 'LEFT'),
                        const SizedBox(width: 60),
                        _buildArrowButton(Icons.keyboard_double_arrow_right_rounded, 'RIGHT'),
                      ],
                    ),
                    const SizedBox(height: 3),
                    _buildArrowButton(Icons.keyboard_double_arrow_down_rounded, 'BACKWARD'),
                    // DANCE! section
                    const SizedBox(height: 35),
                    Text(
                      'DANCE!',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 24,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // First row of dance moves
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        _buildDanceBox('assets/images/Untitled_design__2_-removebg-preview.png', 'DANCE1'),
                        const SizedBox(width: 10),
                        _buildDanceBox('assets/images/otto_1.png', 'DANCE2'),
                        const SizedBox(width: 10),
                        _buildDanceBox('assets/images/Untitled_design__1_-removebg-preview.png', 'DANCE3'),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Second row of dance moves
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        _buildDanceBox('assets/images/Untitled_design__4_-removebg-preview.png', 'DANCE4'),
                        const SizedBox(width: 10),
                        _buildDanceBox('assets/images/Untitled_design__5_-removebg-preview.png', 'DANCE5'),
                        const SizedBox(width: 10),
                        _buildDanceBox('assets/images/Untitled_design__6_-removebg-preview (1).png', 'DANCE6'),
                        const SizedBox(width: 10),
                      ],
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

  Widget _buildArrowButton(IconData icon, String command) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
        size: 40,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black,
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fixedSize: const Size(60, 60),
      ),
      onPressed: () {
        _sendCommand(command);
      },
    );
  }

  Widget _buildDanceBox(String imagePath, String command) {
    return GestureDetector(
      onTap: () {
        _sendCommand(command);
      },
      child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFAFAFA),
        ),
      ),
      alignment: const AlignmentDirectional(0, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          width: 200,
          height: 120,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              color: Colors.white,
              size: 40,
            );
          },
        ),
      ),
    ),
    );
  }
}
