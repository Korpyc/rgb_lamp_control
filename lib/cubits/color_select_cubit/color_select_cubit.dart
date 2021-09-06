import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:rgb_lamp_control/models/color_mode_params.dart';
import 'package:rgb_lamp_control/services/control_services/color_service.dart';

part 'color_select_state.dart';

class ColorSelectCubit extends Cubit<ColorSelectState> {
  final ColorService colorService;
  ColorSelectCubit(
    this.colorService,
  ) : super(ColorSelectInitial());

  Future<void> update(ColorModeParams params) async {
    colorService.update(params);
  }

  Future<void> sendParams({
    int? numberOfColor,
    int? whiteColor,
    int? brightness,
  }) async {
    colorService.sendParams(
      numberOfColor: numberOfColor,
      whiteColor: whiteColor,
      brightness: brightness,
    );
  }
}
