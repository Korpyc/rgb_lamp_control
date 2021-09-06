import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/cubits/rgb_mode_cubit/rgb_mode_cubit.dart';
import 'package:rgb_lamp_control/models/rgb_mode_params.dart';
import 'package:rgb_lamp_control/screens/color_picker_screen/widgets/color_picker_slider.dart';
import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';
import 'package:rgb_lamp_control/services/services.dart';

class ColorPickerScreen extends StatefulWidget {
  ColorPickerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ColorPickerScreenState createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  @override
  Widget build(BuildContext context) {
    RGBModeParams? params;
    if (context.read<BlueDeviceBloc>().state is BlueDeviceConnected) {
      BlueDeviceConnected state =
          context.read<BlueDeviceBloc>().state as BlueDeviceConnected;
      if (state.mode == BlueDeviceMode.rgb &&
          state.parameters != null &&
          state.parameters is RGBModeParams) {
        params = state.parameters;
      }
    }
    return Scaffold(
      body: BlocProvider(
        create: (context) => RGBModeCubit(getIt()),
        child: BlocBuilder<RGBModeCubit, RGBModeState>(
          builder: (context, state) {
            if (params != null) {
              context.read<RGBModeCubit>().update(params);
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorPickerSlider(
                    type: ColorPickerSliderType.brightness,
                    startValue: params?.brightness,
                    onChange: (int value) {
                      context.read<RGBModeCubit>().setRGB(
                            brightness: value,
                          );
                    },
                  ),
                  ColorPickerSlider(
                    type: ColorPickerSliderType.white,
                    startValue: params?.whiteColor,
                    onChange: (int value) {
                      context.read<RGBModeCubit>().setRGB(
                            whiteColor: value,
                          );
                    },
                  ),
                  ColorPickerSlider(
                    type: ColorPickerSliderType.red,
                    startValue: params?.redColor,
                    onChange: (int value) {
                      context.read<RGBModeCubit>().setRGB(
                            redColor: value,
                          );
                    },
                  ),
                  ColorPickerSlider(
                    type: ColorPickerSliderType.green,
                    startValue: params?.greenColor,
                    onChange: (int value) {
                      context.read<RGBModeCubit>().setRGB(
                            greenColor: value,
                          );
                    },
                  ),
                  ColorPickerSlider(
                    type: ColorPickerSliderType.blue,
                    startValue: params?.blueColor,
                    onChange: (int value) {
                      context.read<RGBModeCubit>().setRGB(
                            blueColor: value,
                          );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
