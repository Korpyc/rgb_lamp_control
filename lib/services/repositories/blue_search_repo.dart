import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';
import 'package:rgb_lamp_control/services/bluetooth/blue_search_service.dart';

class BlueSearchRepo {
  late BlueSearchService _blueSearchService;

  BlueSearchRepo(this._blueSearchService);
  void startScanning(int duration) {
    _blueSearchService.startScan(duration: duration);
  }

  Stream<List<FoundDevice>> get foundDevicesStream =>
      _blueSearchService.availableToConnectDeviceList;
}
