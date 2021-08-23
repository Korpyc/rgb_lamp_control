import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_lamp_control/cubits/blue_adapter_cubit/blue_adapter_cubit.dart';
import 'package:rgb_lamp_control/cubits/blue_device_cubit/blue_device_cubit.dart';
import 'package:rgb_lamp_control/screens/blue_off_screen/blue_off_screen.dart';
import 'package:rgb_lamp_control/screens/connection_screen/connection_screen.dart';
import 'package:rgb_lamp_control/screens/tab_screen/tab_screen.dart';
import 'package:rgb_lamp_control/services/services.dart';

void main() {
  servicesSetup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlueAdapterBloc(),
      child: BlocProvider(
        create: (context) => BlueDeviceBloc(),
        child: MaterialApp(
          title: 'Flutter',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocBuilder<BlueAdapterBloc, BlueAdapterState>(
            builder: (context, state) {
              if (state is BlueOnState) {
                return BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
                  builder: (context, state) {
                    if (state is BlueDeviceInitial) {
                      return ConnectionScreen();
                    }
                    return TabScreen();
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
