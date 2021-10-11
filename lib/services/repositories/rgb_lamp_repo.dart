import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';
import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';

enum RgbLampMode {
  rgb,
  color,
  fire,
  undefined,
}

abstract class RgbLampRepo {
  void startScanning(int duration);
  Stream<List<FoundDevice>> get foundDevicesStream;

  Future<void> connectDevice(BluetoothDevice device);
}

class RgbLampRepoImpl extends RgbLampRepo {
  // current mode of lamp light
  RgbLampMode _mode = RgbLampMode.undefined;

  bool get isDeviceConnected => _deviceService.isConnected;

  final BlueDeviceService _deviceService;
  RgbLampRepoImpl(this._deviceService);

  void startScanning(int duration) {
    _deviceService.startScan(duration: duration);
  }

  Stream<List<FoundDevice>> get foundDevicesStream =>
      _deviceService.availableToConnectDeviceList;

  Future<void> connectDevice(BluetoothDevice device) async {}
}
