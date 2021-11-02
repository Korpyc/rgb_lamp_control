import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circular_color_picker/circular_color_picker.dart';

import 'package:rgb_lamp_control/cubits/rgb_mode_cubit/rgb_mode_cubit.dart';
import 'package:rgb_lamp_control/services/control_services/rgb_service.dart';
import 'package:rgb_lamp_control/services/services.dart';

class RgbModeScreen extends StatelessWidget {
  RgbModeScreen({Key? key}) : super(key: key);

  final ValueNotifier<Color> _color = ValueNotifier(Colors.white);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RGBModeCubit(RgbService(getIt())),
      child: BlocBuilder<RGBModeCubit, RGBModeState>(
        builder: (context, state) {
          return Center(
            child: CircularColorPicker(
              radius: 150,
              pickerOptions: CircularColorPickerOptions(
                showBackground: true,
              ),
              pickerDotOptions: PickerDotOptions(
                isInner: true,
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
