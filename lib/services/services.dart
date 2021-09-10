import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';

import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';
import 'package:rgb_lamp_control/services/control_services/color_service.dart';
import 'package:rgb_lamp_control/services/control_services/fire_service.dart';
import 'package:rgb_lamp_control/services/control_services/rgb_service.dart';

final getIt = GetIt.instance;

void servicesSetup() {
  getIt.registerLazySingleton<FlutterBlue>(() => FlutterBlue.instance);
  getIt.registerLazySingleton(() => BlueDeviceService());
  getIt.registerLazySingleton(() => RgbService(getIt()));
  getIt.registerLazySingleton(() => ColorService(getIt()));
  getIt.registerLazySingleton(() => FireService(getIt()));
}
