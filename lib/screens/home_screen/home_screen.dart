import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/screens/rgb_mode_screen/rgb_mode_screen.dart';
import 'package:rgb_lamp_control/screens/select_color_mode_screen/select_color_mode_screen.dart';
import 'package:rgb_lamp_control/services/repositories/rgb_lamp_repo.dart';
import 'package:rgb_lamp_control/services/services.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
        builder: (context, state) {
          if (state is BlueDeviceConnected) {
            switch (state.mode) {
              case RgbLampMode.rgb:
                return RgbModeScreen();
              case RgbLampMode.color:
                return SelectColorModeScreen();
              default:
                Container();
            }
          }
          return Container();
        },
      ),
      drawer: _buildDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
      builder: (context, state) {
        if (state is BlueDeviceConnected) {
          return FloatingActionButton(
            backgroundColor: state.isLampOn ? Colors.green : Colors.red,
            child: Icon(
              Icons.power_settings_new,
            ),
            onPressed: () {
              getIt<BlueDeviceBloc>().add(BlueDeviceLightSwitchEvent());
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
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
                    Column(
                        children: RgbLampMode.values.map<Widget>((mode) {
                      return TextButton(
                        child: Text("$mode"),
                        onPressed: () {
                          context.read<BlueDeviceBloc>().add(
                                BlueDeviceModeSwitchEvent(mode),
                              );
                          Navigator.pop(context);
                        },
                      );
                    }).toList()),
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
