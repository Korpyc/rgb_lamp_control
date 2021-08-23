import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void servicesSetup() {
  getIt.registerLazySingleton<FlutterBlue>(() => FlutterBlue.instance);
}
