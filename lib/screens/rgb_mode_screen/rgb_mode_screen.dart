import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circular_color_picker/circular_color_picker.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/cubits/rgb_mode_cubit/rgb_mode_cubit.dart';
import 'package:rgb_lamp_control/models/rgb_mode_params.dart';
import 'package:rgb_lamp_control/services/control_services/rgb_service.dart';
import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';
import 'package:rgb_lamp_control/services/services.dart';

class RgbModeScreen extends StatelessWidget {
  RgbModeScreen({Key? key}) : super(key: key);

  final ValueNotifier<Color> _color = ValueNotifier(Colors.white);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        RGBModeParams? parameters;
        if (context.read<BlueDeviceBloc>().state is BlueDeviceConnected) {
          BlueDeviceConnected state =
              context.read<BlueDeviceBloc>().state as BlueDeviceConnected;
          if (state.mode == RgbLampMode.rgb &&
              state.parameters != null &&
              state.parameters is RGBModeParams) {
            parameters = state.parameters;
          }
        }
        if (parameters != null) {
          return RGBModeCubit(RgbService(getIt()))..update(parameters);
        } else {
          return RGBModeCubit(RgbService(getIt()));
        }
      },
      child: BlocBuilder<RGBModeCubit, RGBModeState>(
        builder: (context, state) {
          Color initialColor = Color.fromRGBO(
            context.read<RGBModeCubit>().parameters.redColor,
            context.read<RGBModeCubit>().parameters.greenColor,
            context.read<RGBModeCubit>().parameters.blueColor,
            1,
          );
          return Center(
            child: CircularColorPicker(
              radius: 150,
              pickerOptions: CircularColorPickerOptions(
                initialColor: initialColor,
                showBackground: true,
              ),
              pickerDotOptions: PickerDotOptions(
                isInner: false,
              ),
              onColorChange: (color) {
                context.read<RGBModeCubit>().setRGB(
                      redColor: color.red,
                      blueColor: color.blue,
                      greenColor: color.green,
                    );
                _color.value = color;
              },
            ),
          );
        },
      ),
    );
  }
}
