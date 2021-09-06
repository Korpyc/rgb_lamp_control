import 'package:rgb_lamp_control/models/color_mode_params.dart';
import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';
import 'package:rgb_lamp_control/services/control_services/control_service.dart';
import 'package:rgb_lamp_control/util/constants.dart';

class ColorService extends ControlService {
  ColorService(
    BlueDeviceService deviceService,
  ) : super(deviceService);

  ColorModeParams _parameters = ColorModeParams();

  ColorModeParams get parameters => _parameters;

  void update(ColorModeParams params) {
    _parameters = params;
  }

  Future<void> sendParams({
    int? brightness,
    int? whiteColor,
    int? numberOfColor,
  }) async {
    if (deviceService.isConnected) {
      if (deviceService.mode != BlueDeviceMode.color) {
        deviceService.sendData(
          AppConstants.colorModeCommand,
        );
        await Future.delayed(Duration(milliseconds: 5));
      }
      _parameters.update(
          brightness: brightness,
          whiteColor: whiteColor,
          numberOfColor: numberOfColor);

      String setupCommands = '\$2,';
      setupCommands += '${_parameters.brightness},';
      setupCommands += '${_parameters.numberOfColor},';
      setupCommands += '0,';
      setupCommands += '0,';
      setupCommands += '0,';
      setupCommands += '${_parameters.whiteColor},';
      setupCommands += '1;';

      deviceService.sendData(
        setupCommands,
      );
    }
  }
}
