import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

abstract class BlueDeviceService {
  Stream<String> get recievedValueStream;

  bool get isConnected;

  // Function to connect device and setup connection
  Future<void> connectDevice(BluetoothDevice device);

  Future<void> disconnect();

  void processRecievedData(List<int> value);

  // Send string data to device
  Future<void> sendData(String data, {isReload = true});

  void close();
}
