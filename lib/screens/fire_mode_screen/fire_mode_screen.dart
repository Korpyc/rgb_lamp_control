import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/cubits/fire_mode_cubit/fire_mode_cubit.dart';
import 'package:rgb_lamp_control/models/fire_mode_params.dart';
import 'package:rgb_lamp_control/screens/fire_mode_screen/widgets/fire_mode_slider.dart';
import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';
import 'package:rgb_lamp_control/services/services.dart';

class FireModeScreen extends StatefulWidget {
  FireModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _FireModeScreenState createState() => _FireModeScreenState();
}

class _FireModeScreenState extends State<FireModeScreen> {
  @override
  Widget build(BuildContext context) {
    FireModeParams? params;
    if (context.read<BlueDeviceBloc>().state is BlueDeviceConnected) {
      BlueDeviceConnected state =
          context.read<BlueDeviceBloc>().state as BlueDeviceConnected;
      if (state.mode == BlueDeviceMode.fire &&
          state.parameters != null &&
          state.parameters is FireModeParams) {
        params = state.parameters;
      }
    }
    return Scaffold(
      body: BlocProvider<FireModeCubit>(
        create: (context) => FireModeCubit(getIt()),
        child: BlocBuilder<FireModeCubit, FireModeState>(
          builder: (context, state) {
            if (params != null) {
              context.read<FireModeCubit>().update(params);
            }
            return LayoutBuilder(
              builder: (
                context,
                constraints,
              ) =>
                  SizedBox(
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      FireModeSlider(
                        type: FireModeSliderType.brightness,
                        startValue: params?.brightness,
                        onChange: (int value) {
                          context.read<FireModeCubit>().setParams(
                                brightness: value,
                              );
                        },
                      ),
                      FireModeSlider(
                        type: FireModeSliderType.speed,
                        startValue: params?.speed,
                        onChange: (int value) {
                          context.read<FireModeCubit>().setParams(
                                speed: value,
                              );
                        },
                      ),
                      FireModeSlider(
                        type: FireModeSliderType.min,
                        startValue: params?.min,
                        onChange: (int value) {
                          context.read<FireModeCubit>().setParams(
                                min: value,
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
