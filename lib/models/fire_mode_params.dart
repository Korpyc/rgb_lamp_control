import 'package:rgb_lamp_control/util/constants.dart';

class FireModeParams {
  int _brightness; // 1 - 255
  int _speed; // 0 - 1000
  int _min; // 0 - 255

  get brightness => _brightness;
  get speed => _speed;
  get min => _min;

  FireModeParams({
    int brightness = 128,
    int speed = 0,
    int min = 0,
  })  : _brightness = brightness,
        _speed = speed,
        _min = min;

  void update({
    int? brightness,
    int? speed,
    int? min,
  }) {
    if (brightness != null) {
      if (brightness >= AppConstants.minBrightnessValue &&
          brightness <= AppConstants.maxDefaultValue) {
        _brightness = brightness;
      }
    }
    if (speed != null) {
      if (speed >= AppConstants.minDefaultValue &&
          speed <= AppConstants.maxSpeedValue) {
        _speed = speed;
      }
    }
    if (min != null) {
      if (min >= AppConstants.minDefaultValue &&
          min <= AppConstants.maxDefaultValue) {
        _min = min;
      }
    }
  }
}
