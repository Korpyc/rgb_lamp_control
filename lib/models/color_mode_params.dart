import 'package:rgb_lamp_control/util/constants.dart';

class ColorModeParams {
  int _brightness; // 1 - 255
  int _whiteColor; // 0 - 255
  int _numberOfColor; // 0 - 1530

  int get brightness => _brightness;
  int get whiteColor => _whiteColor;
  int get numberOfColor => _numberOfColor;

  ColorModeParams({
    int brightness = 127,
    int whiteColor = 0,
    int numberOfColor = 0,
  })  : _brightness = brightness,
        _whiteColor = whiteColor,
        _numberOfColor = numberOfColor;

  void update({
    int? brightness,
    int? whiteColor,
    int? numberOfColor,
  }) {
    if (brightness != null) {
      if (brightness >= AppConstants.minBrightnessValue &&
          brightness <= AppConstants.maxDefaultValue) {
        _brightness = brightness;
      }
    }
    if (whiteColor != null) {
      if (whiteColor >= AppConstants.minDefaultValue &&
          whiteColor <= AppConstants.maxDefaultValue) {
        _whiteColor = whiteColor;
      }
    }
    if (numberOfColor != null) {
      if (numberOfColor >= AppConstants.minDefaultValue &&
          numberOfColor <= AppConstants.maxNumberOfColorValue) {
        _numberOfColor = numberOfColor;
      }
    }
  }
}
