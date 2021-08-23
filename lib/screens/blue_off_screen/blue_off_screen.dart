import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_lamp_control/cubits/blue_adapter_cubit/blue_adapter_cubit.dart';

class BluetoothErrorScreen extends StatelessWidget {
  const BluetoothErrorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: BlocBuilder<BlueAdapterBloc, BlueAdapterState>(
        builder: (context, state) {
          return Center(
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
          );
        },
      ),
    );
  }
}
