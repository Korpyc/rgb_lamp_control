import 'package:flutter_blue/flutter_blue.dart';

class FoundDevice {
  final String deviceName;
  final String uuid;
  final BluetoothDevice device;

  FoundDevice({
    required this.deviceName,
    required this.device,
    required this.uuid,
  });

  factory FoundDevice.fromScanResult(ScanResult result) {
    return FoundDevice(
      deviceName: result.device.name,
      device: result.device,
      uuid: result.device.id.id,
    );
  }

  @override
  String toString() {
    return 'FoundDevice{device: $device, device name: $deviceName, uuid: $uuid}';
  }
}
