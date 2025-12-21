import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bluetooth_service.dart';

class ManualControlPage extends StatefulWidget {
  const ManualControlPage({super.key});

  @override
  State<ManualControlPage> createState() => _ManualControlPageState();
}

class _ManualControlPageState extends State<ManualControlPage> {
  final OttoBluetoothService _bluetoothService = OttoBluetoothService();

  // Send command via Bluetooth
  Future<void> _sendCommand(String command) async {
    if (!_bluetoothService.isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Not connected to device',
              style: GoogleFonts.pressStart2p(fontSize: 8),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    bool success = await _bluetoothService.sendCommand(command);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send command',
            style: GoogleFonts.pressStart2p(fontSize: 8),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Color(0xFF4F0C0C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Home button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  // Centered controls
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'MOVE!',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 12),

                        _buildArrowButton(
                          Icons.keyboard_double_arrow_up_rounded,
                          'FORWARD',
                        ),

                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildArrowButton(
                              Icons.keyboard_double_arrow_left_rounded,
                              'LEFT',
                            ),
                            const SizedBox(width: 40),
                            _buildArrowButton(
                              Icons.keyboard_double_arrow_right_rounded,
                              'RIGHT',
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        _buildArrowButton(
                          Icons.keyboard_double_arrow_down_rounded,
                          'BACKWARD',
                        ),

                        const SizedBox(height: 36),

                        Text(
                          'DANCE!',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: 330,
                          child: GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildDanceBox(
                                'assets/images/Untitled_design__2_-removebg-preview.png',
                                'DANCE1',
                              ),
                              _buildDanceBox(
                                'assets/images/otto_1.png',
                                'DANCE2',
                              ),
                              _buildDanceBox(
                                'assets/images/Untitled_design__1_-removebg-preview.png',
                                'DANCE3',
                              ),
                              _buildDanceBox(
                                'assets/images/Untitled_design__4_-removebg-preview.png',
                                'DANCE4',
                              ),
                              _buildDanceBox(
                                'assets/images/Untitled_design__5_-removebg-preview.png',
                                'DANCE5',
                              ),
                              _buildDanceBox(
                                'assets/images/Untitled_design__6_-removebg-preview (1).png',
                                'DANCE6',
                              ),
                            ],
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

  Widget _buildArrowButton(IconData icon, String command) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 40),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black,
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          border: Border.all(color: const Color(0xFFFAFAFA)),
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
