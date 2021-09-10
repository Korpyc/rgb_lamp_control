class AppConstants {
  static const String serviceUUID = '6e400001-b5a3-f393-e0a9-e50e24dcca9';

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
