import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

import 'package:rgb_lamp_control/services/bluetooth/blue_device_service.dart';
import 'package:rgb_lamp_control/util/strings.dart';

enum RgbLampMode {
  rgb,
  color,
  fire,
  undefined,
}

abstract class RgbLampRepo {
  Stream get lampUpdates;
  bool get isDeviceConnected;
  Future<void> connectDevice(BluetoothDevice device);
  Future<void> disconnectDevice();
  void close();
}

class RgbLampRepoImpl extends RgbLampRepo {
  StreamSubscription? _lampUpdatesSubscription;

  StreamController<String> _lampUpdatesStreamController =
      StreamController<String>.broadcast();

  Stream get lampUpdates => _lampUpdatesStreamController.stream;

  // current mode of lamp light
  RgbLampMode _mode = RgbLampMode.undefined;

  bool get isDeviceConnected => _deviceService.isConnected;

  final BlueDeviceService _deviceService;
  RgbLampRepoImpl(this._deviceService);

  void _listenUpdatesFromLamp() {
    if (_lampUpdatesSubscription == null) {
      _lampUpdatesSubscription = _deviceService.recievedValueStream.listen(
        (event) {
          if (event == AppStrings.deviceConnected) {
            _lampUpdatesStreamController.sink.add('null');
          }
          log('Update from lamp: ${event.toString()}');
        },
      );
    }
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    try {
      await _deviceService.connectDevice(device);
      _listenUpdatesFromLamp();
    } catch (e) {
      log(e.toString());
      _lampUpdatesSubscription?.cancel();
      _lampUpdatesSubscription = null;
    }
  }

  Future<void> disconnectDevice() async {
    try {
      await _lampUpdatesSubscription?.cancel();
      _lampUpdatesSubscription = null;
      await _deviceService.disconnect();
    } catch (e) {
      log(e.toString());
    }
  }

  void close() {
    _lampUpdatesSubscription?.cancel();
    _lampUpdatesStreamController.close();
    _deviceService.close();
  }
}
