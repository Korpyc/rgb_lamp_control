import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/cubits/color_select_cubit/color_select_cubit.dart';
import 'package:rgb_lamp_control/models/color_mode_params.dart';
import 'package:rgb_lamp_control/screens/color_picker_screen/widgets/color_picker_slider.dart';
import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';
import 'package:rgb_lamp_control/services/services.dart';

class ColorSelectScreen extends StatelessWidget {
  ColorSelectScreen({Key? key}) : super(key: key);

  final ValueNotifier<Color> currentColor = ValueNotifier(Colors.red);

  @override
  Widget build(BuildContext context) {
    ColorModeParams? params;
    if (context.read<BlueDeviceBloc>().state is BlueDeviceConnected) {
      BlueDeviceConnected state =
          context.read<BlueDeviceBloc>().state as BlueDeviceConnected;
      if (state.mode == BlueDeviceMode.color &&
          state.parameters != null &&
          state.parameters is ColorModeParams) {
        params = state.parameters;
        currentColor.value = colorWheel(params!.numberOfColor);
      }
    }
    return BlocProvider(
      create: (context) => ColorSelectCubit(getIt()),
      child: BlocBuilder<ColorSelectCubit, ColorSelectState>(
        builder: (context, state) {
          if (params != null) {
            context.read<ColorSelectCubit>().update(params);
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorPickerSlider(
                  startValue: params?.brightness,
                  type: ColorPickerSliderType.brightness,
                  onChange: (int value) {
                    context.read<ColorSelectCubit>().sendParams(
                          brightness: value,
                        );
                  },
                ),
                ColorPickerSlider(
                  startValue: params?.whiteColor,
                  type: ColorPickerSliderType.white,
                  onChange: (int value) {
                    context.read<ColorSelectCubit>().sendParams(
                          whiteColor: value,
                        );
                  },
                ),
                ValueListenableBuilder<Color>(
                  valueListenable: currentColor,
                  builder: (context, value, child) => Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SleekCircularSlider(
                  initialValue: params?.numberOfColor.toDouble() ?? 0.0,
                  min: 0,
                  max: 1530,
                  appearance: CircularSliderAppearance(
                    animationEnabled: false,
                    customWidths: CustomSliderWidths(
                      handlerSize: 12,
                      progressBarWidth: 48,
                      trackWidth: 12,
                    ),
                    customColors: CustomSliderColors(
                      progressBarColors: [
                        Color.fromRGBO(255, 0, 0, 1),
                        Color.fromRGBO(255, 0, 254, 1),
                        Color.fromRGBO(255, 0, 255, 1),
                        Color.fromRGBO(1, 0, 255, 1),
                        Color.fromRGBO(0, 0, 255, 1),
                        Color.fromRGBO(0, 254, 255, 1),
                        Color.fromRGBO(0, 255, 255, 1),
                        Color.fromRGBO(0, 255, 1, 1),
                        Color.fromRGBO(0, 255, 0, 1),
                        Color.fromRGBO(254, 255, 0, 1),
                        Color.fromRGBO(255, 255, 0, 1),
                        Color.fromRGBO(255, 0, 0, 1),
                      ],
                    ),
                    infoProperties: InfoProperties(modifier: (value) {
                      return '${value.round()}';
                    }),
                    size: MediaQuery.of(context).size.width * 0.8,
                    startAngle: 180,
                    angleRange: 180,
                  ),
                  onChange: (double value) {
                    currentColor.value = colorWheel(value.round());
                    context.read<ColorSelectCubit>().sendParams(
                          numberOfColor: value.round(),
                        );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color colorWheel(int color) {
    int redColor = 0;
    int greenColor = 0;
    int blueColor = 0;

    if (color <= 255) {
      // красный макс, зелёный растёт
      redColor = 255;
      greenColor = color;
      blueColor = 0;
    } else if (color > 255 && color <= 510) {
      // зелёный макс, падает красный
      redColor = 510 - color;
      greenColor = 255;
      blueColor = 0;
    } else if (color > 510 && color <= 765) {
      // зелёный макс, растёт синий
      redColor = 0;
      greenColor = 255;
      blueColor = color - 510;
    } else if (color > 765 && color <= 1020) {
      // синий макс, падает зелёный
      redColor = 0;
      greenColor = 1020 - color;
      blueColor = 255;
    } else if (color > 1020 && color <= 1275) {
      // синий макс, растёт красный
      redColor = color - 1020;
      greenColor = 0;
      blueColor = 255;
    } else if (color > 1275 && color <= 1530) {
      // красный макс, падает синий
      redColor = 255;
      greenColor = 0;
      blueColor = 1530 - color;
    }
    return Color.fromRGBO(redColor, greenColor, blueColor, 1);
  }
}
