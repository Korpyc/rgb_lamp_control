import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';

import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';

final getIt = GetIt.instance;

void servicesSetup() {
  getIt.registerLazySingleton<FlutterBlue>(() => FlutterBlue.instance);
  getIt.registerLazySingleton(() => BlueDeviceService());
}
