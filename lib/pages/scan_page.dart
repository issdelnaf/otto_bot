import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bluetooth_service.dart';
import 'modes_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final OttoBluetoothService _bluetoothService = OttoBluetoothService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkBluetoothAndScan();
  }

  Future<void> _checkBluetoothAndScan() async {
    // Check if bluetooth is supported
    if (!await _bluetoothService.isBluetoothSupported()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bluetooth not supported on this device'),
          ),
        );
      }
      return;
    }

    // Start scanning
    _startScan();
  }

  Future<void> _startScan() async {
    if (!mounted) return;

    setState(() {
      _isScanning = true;
    });

    try {
      await _bluetoothService.startScan();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error starting scan: $e')));
      }
    }

    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    // Stop scanning before connecting
    await _bluetoothService.stopScan();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool connected = await _bluetoothService.connectToDevice(device);

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog

      if (connected) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ModesPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to connect to device',
              style: GoogleFonts.pressStart2p(fontSize: 8),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _bluetoothService.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'SCAN DEVICES',
          style: GoogleFonts.pressStart2p(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.stop : Icons.refresh),
            color: Colors.white,
            onPressed: () async {
              if (_isScanning) {
                await _bluetoothService.stopScan();
                setState(() {
                  _isScanning = false;
                });
              } else {
                _startScan();
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF4F0C0C)],
            stops: [0, 1],
            begin: AlignmentDirectional(0, -1),
            end: AlignmentDirectional(0, 1),
          ),
        ),
        child: StreamBuilder<List<ScanResult>>(
          stream: _bluetoothService.scanResults,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  _isScanning ? 'Scanning...' : 'No devices found',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              );
            }

            // Show all devices, but put named ones first
            final results = snapshot.data!;

            results.sort((a, b) {
              final aName = a.advertisementData.advName;
              final bName = b.advertisementData.advName;
              if (aName.isNotEmpty && bName.isEmpty) return -1;
              if (aName.isEmpty && bName.isNotEmpty) return 1;
              return 0;
            });

            if (results.isEmpty) {
              return Center(
                child: Text(
                  'No devices found',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  color: Colors.white.withValues(alpha: 0.1),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      result.advertisementData.advName.isNotEmpty
                          ? result.advertisementData.advName
                          : 'Unknown Device',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Text(
                      result.device.remoteId.toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => _connectToDevice(result.device),
                      child: Text(
                        'CONNECT',
                        style: GoogleFonts.pressStart2p(fontSize: 10),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
