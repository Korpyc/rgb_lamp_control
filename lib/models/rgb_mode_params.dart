import 'package:rgb_lamp_control/util/constants.dart';

class RGBModeParams {
  int _brightness; // 1 - 255
  int _whiteColor; // 0 - 255
  int _redColor; // 0 - 255
  int _greenColor; // 0 - 255
  int _blueColor; // 0 - 255

  get brightness => _brightness;
  get whiteColor => _whiteColor;
  get redColor => _redColor;
  get greenColor => _greenColor;
  get blueColor => _blueColor;

  RGBModeParams({
    int brightness = 128,
    int whiteColor = 0,
    int redColor = 0,
    int greenColor = 0,
    int blueColor = 0,
  })  : _brightness = brightness,
        _whiteColor = whiteColor,
        _redColor = redColor,
        _greenColor = greenColor,
        _blueColor = blueColor;

  void update({
    int? brightness,
    int? whiteColor,
    int? redColor,
    int? greenColor,
    int? blueColor,
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
    if (redColor != null) {
      if (redColor >= AppConstants.minDefaultValue &&
          redColor <= AppConstants.maxDefaultValue) {
        _redColor = redColor;
      }
    }
    if (greenColor != null) {
      if (greenColor >= AppConstants.minDefaultValue &&
          greenColor <= AppConstants.maxDefaultValue) {
        _greenColor = greenColor;
      }
    }
    if (blueColor != null) {
      if (blueColor >= AppConstants.minDefaultValue &&
          blueColor <= AppConstants.maxDefaultValue) {
        _blueColor = blueColor;
      }
    }
  }
}
