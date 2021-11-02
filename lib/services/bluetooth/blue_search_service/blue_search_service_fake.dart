import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';
import 'package:rgb_lamp_control/services/bluetooth/blue_search_service/blue_search_service.dart';

class BlueSearchServiceFake extends BlueSearchService {
  bool _isScanStarted = false;

  late FlutterBlue _bluetoothInstance;

  StreamSubscription? _scanResultsListener;

  StreamController<List<FoundDevice>> _availableToConnectDeviceList =
      StreamController<List<FoundDevice>>();

  Stream<List<FoundDevice>> get availableToConnectDeviceList =>
      _availableToConnectDeviceList.stream;

  BlueSearchServiceFake(this._bluetoothInstance) {
    init();
  }

  void init() {
    _initListenersOfBluetooth();
  }

  void _initListenersOfBluetooth() {
    _scanResultsListener = _bluetoothInstance.scanResults.listen(
      (results) {
        List<FoundDevice> listOfFoundedDevices = [];
        for (ScanResult result in results) {
          try {
            FoundDevice device = FoundDevice.fromScanResult(result);
            listOfFoundedDevices.add(device);
          } catch (e) {
            print(e.toString());
          }
        }
        _availableToConnectDeviceList.sink.add(listOfFoundedDevices);
      },
    );
  }

  Future<void> startScan({int duration = 4}) async {
    if (!_isScanStarted) {
      _isScanStarted = true;
      List<ScanResult> result = await _bluetoothInstance.startScan(
        timeout: Duration(seconds: duration),
      );
      _isScanStarted = false;
      if (result.isEmpty) {
        _availableToConnectDeviceList.sink.add([]);
      }
    }
  }

  void close() {
    _scanResultsListener?.cancel();
    _availableToConnectDeviceList.close();
  }
}
