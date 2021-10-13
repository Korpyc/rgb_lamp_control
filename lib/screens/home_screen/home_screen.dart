import 'package:flutter/material.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            getIt<BlueDeviceBloc>().add(BlueDeviceDisconnectEvent());
          },
          child: Text('press'),
        ),
      ),
    );
  }
}
