import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_adapter_state_bloc/blue_adapter_state_bloc.dart';
import 'package:rgb_lamp_control/screens/blue_adapter_status_screen/blue_adapter_status_screen.dart';
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
      create: (context) => BlueAdapterStateBloc(),
      child: MaterialApp(
        home: BlocConsumer<BlueAdapterStateBloc, BlueAdapterState>(
          listener: (context, state) {
            //Navigator.of(context).popUntil((route) => route.isFirst);
          },
          builder: (context, state) {
            if (state is BlueAdapterOnState) {
              return MainScreen();
            } else {
              return BluetoothAdapterStatusScreen(
                state: state,
              );
            }
          },
        ),
      ),
    );
  }
}
