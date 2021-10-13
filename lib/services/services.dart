import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/services/bluetooth/blue_device_service.dart';
import 'package:rgb_lamp_control/services/bluetooth/blue_search_service.dart';
import 'package:rgb_lamp_control/services/repositories/blue_search_repo.dart';
import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';

final getIt = GetIt.instance;

void servicesSetup() {
  getIt.registerLazySingleton<FlutterBlue>(() => FlutterBlue.instance);
  getIt.registerLazySingleton(() => BlueDeviceService());
  getIt.registerLazySingleton(() => BlueSearchService(getIt()));
  getIt.registerLazySingleton(() => BlueSearchRepo(getIt()));
  getIt.registerLazySingleton<RgbLampRepo>(() => RgbLampRepoImpl(getIt()));
  getIt.registerLazySingleton(() => BlueDeviceBloc(getIt()));
}
