import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:rgb_lamp_control/models/fire_mode_params.dart';
import 'package:rgb_lamp_control/services/control_services/fire_service.dart';

part 'fire_mode_state.dart';

class FireModeCubit extends Cubit<FireModeState> {
  final FireService fireService;
  FireModeCubit(
    this.fireService,
  ) : super(FireModeInitial());

  Future<void> update(FireModeParams params) async {
    fireService.update(params);
  }

  Future<void> setParams({
    int? brightness,
    int? speed,
    int? min,
  }) async {
    await fireService.sendParams(
      brightness: brightness,
      speed: speed,
      min: min,
    );
  }
}
