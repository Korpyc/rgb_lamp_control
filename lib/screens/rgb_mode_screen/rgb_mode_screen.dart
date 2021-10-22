import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/cubits/rgb_mode_cubit/rgb_mode_cubit.dart';
import 'package:rgb_lamp_control/screens/rgb_mode_screen/widgets/rgb_rounded_picker.dart';
import 'package:rgb_lamp_control/services/control_services/rgb_service.dart';
import 'package:rgb_lamp_control/services/services.dart';

class RgbModeScreen extends StatelessWidget {
  const RgbModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RGBModeCubit(RgbService(getIt())),
      child: BlocBuilder<RGBModeCubit, RGBModeState>(
        builder: (context, state) {
          return Stack(
            children: [
              ColorPickerView(
                radius: 150,
                thumbRadius: 20,
                colorListener: (color) {
                  print(color.toString());
                  context.read<RGBModeCubit>().setRGB(
                        redColor: color.red,
                        blueColor: color.blue,
                        greenColor: color.green,
                      );
                  // must be writen code to send Color to device
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
