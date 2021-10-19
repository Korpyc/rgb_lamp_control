import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/screens/rgb_mode_screen/rgb_mode_screen.dart';
import 'package:rgb_lamp_control/services/services.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
        builder: (context, state) {
          if (state is BlueDeviceConnected) {
            return RgbModeScreen();
          }
          return Container();
        },
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
              builder: (context, state) {
                if (state is BlueDeviceConnected) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(state.isLampOn.toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(state.mode.toString()),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildDisconnectButton(),
                      ),
                    ],
                  );
                } else
                  return _buildDisconnectButton();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisconnectButton() {
    return MaterialButton(
      onPressed: () {
        getIt<BlueDeviceBloc>().add(BlueDeviceDisconnectEvent());
      },
      color: Colors.blue,
      child: Text('Disconnect'),
    );
  }
}
