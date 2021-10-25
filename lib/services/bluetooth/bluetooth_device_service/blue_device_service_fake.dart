import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/services/bluetooth/bluetooth_device_service/blue_device_service.dart';
import 'package:rgb_lamp_control/util/strings.dart';

class BlueDeviceServiceFake extends BlueDeviceService {
  StreamSubscription? _listenPortSubscription;
  StreamSubscription? _deviceStatusSubscription;

  StreamController<String> _deviceUpdatesStreamController =
      StreamController<String>();

  Stream<String> get recievedValueStream =>
      _deviceUpdatesStreamController.stream;

  bool get isConnected => _isDeviceConnected;
  bool _isDeviceConnected = false;

  // Function to connect device and setup connection
  Future<void> connectDevice(BluetoothDevice device) async {
    try {
      if (_deviceUpdatesStreamController.isClosed) {
        _deviceUpdatesStreamController = StreamController<String>();
      }

      _isDeviceConnected = true;
      _deviceUpdatesStreamController.sink.add(AppStrings.deviceConnected);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> disconnect() async {
    try {
      _isDeviceConnected = false;
      _deviceUpdatesStreamController.sink.add(
        AppStrings.deviceDisconnected,
      );

      await _deviceStatusSubscription?.cancel();
      _deviceStatusSubscription = null;
      await _listenPortSubscription?.cancel();
      _listenPortSubscription = null;

      await Future.delayed(Duration(milliseconds: 100));
    } catch (e) {
      log(e.toString());
    }
  }

  void processRecievedData(List<int> value) {}

  // Send string data to device
  Future<void> sendData(String data, {isReload = true}) async {}

  void close() {
    _listenPortSubscription?.cancel();
    _deviceUpdatesStreamController.sink.close();
    _deviceUpdatesStreamController.close();
    _deviceStatusSubscription?.cancel();
  }
}
