import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

class BluetoothService {
  fbp.BluetoothDevice? connectedDevice;
  fbp.BluetoothCharacteristic? writeCharacteristic;

  // Connect to device
  Future<bool> connectToDevice(fbp.BluetoothDevice device) async {
    try {
      await device.connect(license: fbp.License.free);
      connectedDevice = device;

      // Discover services
      List<fbp.BluetoothService> services = await device.discoverServices();
      
      // Find the write characteristic (adjust UUID as needed for your ESP32)
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write) {
            writeCharacteristic = characteristic;
            break;
          }
        }
      }

      return true;
    } catch (e) {
      print('Error connecting to device: $e');
      return false;
    }
  }

  // Disconnect from device
  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
      writeCharacteristic = null;
    }
  }

  // Send command to esp
  Future<bool> sendCommand(String command) async {
    if (writeCharacteristic == null) {
      print('No write characteristic available');
      return false;
    }

    try {
      await writeCharacteristic!.write(command.codeUnits);
      print('Command sent: $command');
      return true;
    } catch (e) {
      print('Error sending command: $e');
      return false;
    }
  }
}
