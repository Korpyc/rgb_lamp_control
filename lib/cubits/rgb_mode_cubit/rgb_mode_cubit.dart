import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:rgb_lamp_control/models/rgb_mode_params.dart';
import 'package:rgb_lamp_control/services/control_services/rgb_service.dart';

part 'rgb_mode_state.dart';

class RGBModeCubit extends Cubit<RGBModeState> {
  final RgbService rgbService;
  RGBModeCubit(
    this.rgbService,
  ) : super(RGBModeInitial());

  Future<void> update(RGBModeParams params) async {
    rgbService.update(params);
  }

  Future<void> setRGB({
    int? redColor,
    int? greenColor,
    int? blueColor,
    int? whiteColor,
    int? brightness,
  }) async {
    await rgbService.sendParams(
      blueColor: blueColor,
      greenColor: greenColor,
      redColor: redColor,
      whiteColor: whiteColor,
      brightness: brightness,
    );
  }
}
