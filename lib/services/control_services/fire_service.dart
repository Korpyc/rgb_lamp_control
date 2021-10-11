/* import 'package:rgb_lamp_control/models/fire_mode_params.dart';
import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';
import 'package:rgb_lamp_control/services/control_services/control_service.dart';
import 'package:rgb_lamp_control/util/constants.dart';

class FireService extends ControlService {
  FireService(
    BlueDeviceService deviceService,
  ) : super(deviceService);

  FireModeParams _parameters = FireModeParams();

  FireModeParams get parameters => _parameters;

  void update(FireModeParams params) {
    _parameters = params;
  }

  @override
  Future<void> sendParams({
    int? brightness,
    int? speed,
    int? min,
  }) async {
    if (deviceService.isConnected) {
      if (deviceService.mode != BlueDeviceMode.fire) {
        deviceService.sendData(
          AppConstants.fireModeCommand,
        );
        await Future.delayed(Duration(milliseconds: 5));
      }
      _parameters.update(
        brightness: brightness,
        speed: speed,
        min: min,
      );

      String setupCommands = '\$2,';
      setupCommands += '${_parameters.brightness},';
      setupCommands += '${_parameters.speed},';
      setupCommands += '${_parameters.min},';
      setupCommands += '0,';
      setupCommands += '0,';
      setupCommands += '0,';
      setupCommands += '1;';

      deviceService.sendData(
        setupCommands,
      );
    }
  }
}
 */