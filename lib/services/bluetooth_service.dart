import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class OttoBluetoothService {
  OttoBluetoothService._internal();
  static final OttoBluetoothService _instance =
      OttoBluetoothService._internal();

  factory OttoBluetoothService() => _instance;

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  // Check if Bluetooth is supported
  Future<bool> isBluetoothSupported() async {
    return await FlutterBluePlus.isSupported;
  }

  // Scan for BLE devices
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      // Turn on Bluetooth on Android if needed
      if (!kIsWeb && Platform.isAndroid) {
        try {
          await FlutterBluePlus.turnOn();
        } catch (e) {
          debugPrint("Could not turn on Bluetooth: $e");
        }
      }

      if (!await FlutterBluePlus.isSupported) {
        debugPrint("Bluetooth not supported on this device");
        throw Exception("Bluetooth not supported on this device");
      }

      // Check if already scanning
      if (await FlutterBluePlus.isScanning.first) {
        debugPrint("Already scanning");
        return;
      }

      await FlutterBluePlus.startScan(timeout: timeout);

      debugPrint("Started BLE scan");
    } catch (e) {
      debugPrint("Error starting scan: $e");
      rethrow;
    }
  }

  // Stop scanning
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // Get scan results stream
  Stream<List<ScanResult>> get scanResults =>
      FlutterBluePlus.onScanResults.map((results) => results.take(5).toList());

  // Connect to a BLE device and find writable characteristic
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      // Disconnect from any existing device first
      if (_connectedDevice != null) {
        await disconnect();
      }

      debugPrint("Connecting to ${device.platformName}...");

      await device.connect(
        timeout: const Duration(seconds: 10),
        license: License.free,
      );
      _connectedDevice = device;
      debugPrint("Connected to device");

      // Monitor connection state
      _connectionSubscription = device.connectionState.listen((state) {
        debugPrint("Connection state: $state");
        if (state == BluetoothConnectionState.disconnected) {
          debugPrint("Device disconnected");
          _connectedDevice = null;
          _writeCharacteristic = null;
          _connectionSubscription?.cancel();
        }
      }, onError: (e) => debugPrint("Connection state error: $e"));

      // Discover services
      debugPrint("Discovering services...");
      List<BluetoothService> services = await device.discoverServices();
      debugPrint("Found ${services.length} services");

      for (final service in services) {
        debugPrint("Service UUID: ${service.uuid}");
        for (final char in service.characteristics) {
          debugPrint(
            "  Characteristic UUID: ${char.uuid}, properties: write=${char.properties.write}, writeWithoutResponse=${char.properties.writeWithoutResponse}",
          );
          if (char.properties.write || char.properties.writeWithoutResponse) {
            _writeCharacteristic = char;
            debugPrint("Writable characteristic found: ${char.uuid}");
            return true;
          }
        }
      }

      debugPrint("No writable characteristic found");
      await disconnect();
      return false;
    } catch (e) {
      debugPrint("Connection failed: $e");
      await disconnect();
      return false;
    }
  }

  // Disconnect from the current device
  Future<void> disconnect() async {
    try {
      await _connectionSubscription?.cancel();
      _connectionSubscription = null;

      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
        _connectedDevice = null;
      }

      _writeCharacteristic = null;
      debugPrint("Disconnected from device");
    } catch (e) {
      debugPrint("Error disconnecting: $e");
    }
  }

  // Send command to ESP32
  Future<bool> sendCommand(String command) async {
    if (_writeCharacteristic == null) {
      debugPrint("No writable characteristic available");
      return false;
    }

    try {
      await _writeCharacteristic!.write(
        command.codeUnits,
        withoutResponse: true,
      );
      debugPrint("Command sent: $command");
      return true;
    } catch (e) {
      debugPrint("Failed to send command: $e");
      return false;
    }
  }

  // Check connection status
  bool get isConnected => _connectedDevice != null;
}
