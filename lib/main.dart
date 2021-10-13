import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_adapter_state_bloc/blue_adapter_state_bloc.dart';
import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/screens/blue_adapter_status_screen/blue_adapter_status_screen.dart';
import 'package:rgb_lamp_control/screens/root_screen/root_screen.dart';
import 'package:rgb_lamp_control/services/services.dart';

void main() {
  servicesSetup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlueAdapterStateBloc(),
        ),
        BlocProvider(
          create: (context) => getIt<BlueDeviceBloc>(),
        ),
      ],
      child: MaterialApp(
        home: SafeArea(
          child: BlocConsumer<BlueAdapterStateBloc, BlueAdapterState>(
            listener: (context, state) {
              //Navigator.of(context).popUntil((route) => route.isFirst);
            },
            builder: (context, state) {
              if (state is BlueAdapterOnState) {
                return RootScreen();
              } else {
                return BluetoothAdapterStatusScreen(
                  state: state,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
