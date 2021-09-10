import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/screens/color_picker_screen/color_picker_screen.dart';
import 'package:rgb_lamp_control/screens/color_select_screen/color_select_screen.dart';
import 'package:rgb_lamp_control/screens/fire_mode_screen/fire_mode_screen.dart';
import 'package:rgb_lamp_control/services/blue_device/blue_device_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<BottomNavigationBarItem> _listOfTabs;
  @override
  void initState() {
    super.initState();

    _listOfTabs = [
      BottomNavigationBarItem(
        icon: Icon(Icons.colorize),
        label: 'RGB',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.color_lens),
        label: 'Color',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.fireplace),
        label: 'Fire',
      ),
    ];
  }

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
        builder: (context, state) {
          if (state is BlueDeviceConnected) {
            switch (state.mode) {
              case BlueDeviceMode.rgb:
                {
                  changeScreenIndex(0);
                  return ColorPickerScreen();
                }
              case BlueDeviceMode.color:
                {
                  changeScreenIndex(1);
                  return ColorSelectScreen();
                }
              case BlueDeviceMode.fire:
                {
                  changeScreenIndex(2);
                  return FireModeScreen();
                }

              default:
                {
                  AbsorbPointer(
                    child: Stack(
                      children: [
                        ColorPickerScreen(),
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  );
                }
            }
          }
          return AbsorbPointer(
            child: Stack(
              children: [
                ColorPickerScreen(),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, value, child) => BottomNavigationBar(
          items: _listOfTabs,
          currentIndex: value,
          onTap: (int index) {
            context.read<BlueDeviceBloc>().add(
                  BlueDeviceChangeMode(
                    BlueDeviceMode.values[index],
                  ),
                );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
        builder: (context, state) {
          Color buttonColor = Colors.red;
          if (state is BlueDeviceConnected) {
            buttonColor = state.isLedEnabled ? Colors.green : Colors.red;
          }
          return FloatingActionButton(
            backgroundColor: buttonColor,
            onPressed: () {
              context.read<BlueDeviceBloc>().add(BlueDeviceSwitchLight());
            },
            child: Icon(Icons.disabled_by_default),
          );
        },
      ),
    );
  }

  void changeScreenIndex(int index) {
    Future.delayed(
      Duration(microseconds: 1),
      () {
        _selectedIndex.value = index;
      },
    );
  }
}
