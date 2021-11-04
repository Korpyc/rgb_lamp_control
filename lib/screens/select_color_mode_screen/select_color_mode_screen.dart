import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/cubits/color_select_cubit/color_select_cubit.dart';
import 'package:rgb_lamp_control/models/color_mode_params.dart';
import 'package:rgb_lamp_control/services/control_services/color_service.dart';
import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';
import 'package:rgb_lamp_control/services/services.dart';

class SelectColorModeScreen extends StatelessWidget {
  SelectColorModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        ColorModeParams? parameters;
        if (context.read<BlueDeviceBloc>().state is BlueDeviceConnected) {
          BlueDeviceConnected state =
              context.read<BlueDeviceBloc>().state as BlueDeviceConnected;
          if (state.mode == RgbLampMode.color &&
              state.parameters != null &&
              state.parameters is ColorModeParams) {
            parameters = state.parameters;
          }
        }
        if (parameters != null) {
          return ColorSelectCubit(ColorService(getIt()))..update(parameters);
        } else {
          return ColorSelectCubit(ColorService(getIt()));
        }
      },
      child: BlocBuilder<ColorSelectCubit, ColorSelectState>(
        builder: (context, state) {
          return Container(
            color: Color.fromRGBO(239, 250, 230, 1),
            child: Center(
              child: MaterialColorPicker(
                circleSize: 64,
                allowShades: false,
                elevation: 6,
                spacing: 12,
                onMainColorChange: (color) {
                  if (color != null) {
                    context.read<ColorSelectCubit>().sendParams(
                          numberOfColor: _colors.lastIndexOf(color),
                        );
                  }
                },
                selectedColor: _colors.elementAt(
                  context.read<ColorSelectCubit>().parameters.numberOfColor,
                ),
                colors: _colors,
              ),
            ),
          );
        },
      ),
    );
  }

  final List<ColorSwatch> _colors = [
    _calculateColorSwatch(255, 255, 255), // white
    _calculateColorSwatch(192, 192, 192), // silver
    Colors.grey,
    _calculateColorSwatch(0, 0, 0), // black
    Colors.red,
    _calculateColorSwatch(128, 0, 0), // maroon
    Colors.yellow,
    _calculateColorSwatch(128, 128, 0), // olive
    _calculateColorSwatch(0, 255, 0), // lime
    Colors.green,
    _calculateColorSwatch(0, 255, 255), // aqua
    _calculateColorSwatch(0, 128, 128), // teal
    Colors.blue,
    _calculateColorSwatch(0, 0, 128), // navy
    Colors.pink,
    Colors.purple,
  ];

  static ColorSwatch _calculateColorSwatch(int r, int g, int b) {
    return ColorSwatch(
      Color.fromRGBO(r, g, b, 1).value,
      {
        50: Color.fromRGBO(r, g, b, .1),
        100: Color.fromRGBO(r, g, b, .2),
        200: Color.fromRGBO(r, g, b, .3),
        300: Color.fromRGBO(r, g, b, .4),
        400: Color.fromRGBO(r, g, b, .5),
        500: Color.fromRGBO(r, g, b, .6),
        600: Color.fromRGBO(r, g, b, .7),
        700: Color.fromRGBO(r, g, b, .8),
        800: Color.fromRGBO(r, g, b, .9),
        900: Color.fromRGBO(r, g, b, 1),
      },
    );
  }
}
