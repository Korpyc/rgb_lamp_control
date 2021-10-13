import 'package:rgb_lamp_control/services/bluetooth/blue_device_service.dart';

abstract class ControlService {
  final BlueDeviceService deviceService;
  ControlService(
    this.deviceService,
  );

  Future<void> sendParams();
}
