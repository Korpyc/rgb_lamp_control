import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';

abstract class BlueSearchService {
  BlueSearchService();
  Stream<List<FoundDevice>> get availableToConnectDeviceList;

  Future<void> startScan({int duration = 4});
  void close();
}
