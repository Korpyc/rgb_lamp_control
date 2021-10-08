import 'package:flutter/material.dart';

import 'package:rgb_lamp_control/blocs/blue_adapter_state_bloc/blue_adapter_state_bloc.dart';

class BluetoothAdapterStatusScreen extends StatelessWidget {
  final BlueAdapterState state;
  const BluetoothAdapterStatusScreen({
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString()}.',
            ),
          ],
        ),
      ),
    );
  }
}
