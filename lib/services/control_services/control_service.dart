import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';

abstract class ControlService {
  final BlueDeviceService deviceService;
  ControlService(
    this.deviceService,
  );

  Future<void> sendParams();
}
