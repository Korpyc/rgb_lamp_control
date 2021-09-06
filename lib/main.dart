import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/cubits/blue_adapter_cubit/blue_adapter_cubit.dart';
import 'package:rgb_lamp_control/screens/blue_off_screen/blue_off_screen.dart';
import 'package:rgb_lamp_control/screens/connection_screen/connection_screen.dart';
import 'package:rgb_lamp_control/screens/main_screen/main_screen.dart';
import 'package:rgb_lamp_control/services/services.dart';

void main() {
  servicesSetup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlueAdapterCubit(),
      child: BlocProvider(
        create: (context) => BlueDeviceBloc(
          deviceService: getIt(),
        ),
        child: MaterialApp(
          title: 'Flutter',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocBuilder<BlueAdapterCubit, BlueAdapterState>(
            builder: (context, state) {
              if (state is BlueOnState) {
                return BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
                  builder: (context, state) {
                    if (state is BlueDeviceInitial) {
                      return ConnectionScreen();
                    }
                    return MainScreen();
                  },
                );
              } else if (state is BlueAdapterInitial) {
                return Container();
              } else {
                return BluetoothErrorScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
