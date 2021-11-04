import 'package:rgb_lamp_control/models/color_mode_params.dart';
import 'package:rgb_lamp_control/services/control_services/control_service.dart';
import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';
import 'package:rgb_lamp_control/util/constants.dart';

class ColorService extends ControlService {
  ColorService(
    RgbLampRepo lampRepo,
  ) : super(lampRepo);
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
    if (lampRepo.isDeviceConnected) {
      if (lampRepo.currentMode != RgbLampMode.color) {
        lampRepo.sendData(
          AppConstants.colorSetModeCommand,
        );
        await Future.delayed(Duration(milliseconds: 5));
      }
      _parameters.update(
        brightness: brightness,
        whiteColor: whiteColor,
        numberOfColor: numberOfColor,
      );

      String setupCommands = '\$2,';
      setupCommands += '${_parameters.brightness},';
      setupCommands += '${_parameters.numberOfColor},';
      setupCommands += '0,';
      setupCommands += '0,';
      setupCommands += '0,';
      setupCommands += '${_parameters.whiteColor},';
      setupCommands += '1;';

      lampRepo.sendData(
        setupCommands,
      );
    }
  }
}
