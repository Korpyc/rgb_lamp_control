class AppConstants {
  static const String serviceUUID = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';

  static const String rgbModeCommand = '\$4,0;';
  static const String hsvModeCommand = '\$4,1;';
  static const String colorModeCommand = '\$4,2;';
  static const String colorSetModeCommand = '\$4,3;';
  static const String kelvinModeCommand = '\$4,4;';
  static const String colorWModeCommand = '\$4,5;';
  static const String fireModeCommand = '\$4,6;';
  static const String fireMModeCommand = '\$4,7;';
  static const String strobeModeCommand = '\$4,8;';
  static const String strobeRModeCommand = '\$4,9;';
  static const String policeModeCommand = '\$4,10;';

  // default values
  static const int minDefaultValue = 0;
  static const int maxDefaultValue = 255;

  // brightness values
  static const int minBrightnessValue = 1;

  // Maximum color number value
  static const int maxNumberOfColorValue = 1530;

  // Maximun speed value
  static const int maxSpeedValue = 1000;
}
