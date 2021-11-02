import 'package:rgb_lamp_control/models/rgb_mode_params.dart';
import 'package:rgb_lamp_control/services/control_services/control_service.dart';
import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';
import 'package:rgb_lamp_control/util/constants.dart';

class RgbService extends ControlService {
  RgbService(
    RgbLampRepo lampRepo,
  ) : super(lampRepo);

  RGBModeParams _parameters = RGBModeParams();

  RGBModeParams get parameters => _parameters;

  void update(RGBModeParams params) {
    _parameters = params;
  }

  @override
  Future<void> sendParams({
    int? brightness,
    int? whiteColor,
    int? redColor,
    int? greenColor,
    int? blueColor,
  }) async {
    if (lampRepo.isDeviceConnected) {
      if (lampRepo.currentMode != RgbLampMode.rgb) {
        lampRepo.sendData(
          AppConstants.rgbModeCommand,
        );
        await Future.delayed(Duration(milliseconds: 5));
      }
      _parameters.update(
        brightness: brightness,
        whiteColor: whiteColor,
        redColor: redColor,
        greenColor: greenColor,
        blueColor: blueColor,
      );

      String setupCommands = '\$2,';
      setupCommands += '${_parameters.brightness},';
      setupCommands += '${_parameters.redColor},';
      setupCommands += '${_parameters.greenColor},';
      setupCommands += '${_parameters.blueColor},';
      setupCommands += '0,';
      setupCommands += '${_parameters.whiteColor},';
      setupCommands += '1;';

      lampRepo.sendData(
        setupCommands,
      );
    }
  }
}
