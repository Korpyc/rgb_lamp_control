import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/blocs/blue_search_bloc/blue_search_bloc.dart';
import 'package:rgb_lamp_control/screens/blue_connection_screen/blue_connection_screen.dart';
import 'package:rgb_lamp_control/screens/home_screen/home_screen.dart';
import 'package:rgb_lamp_control/screens/rgb_mode_screen/widgets/rgb_rounded_picker.dart';
import 'package:rgb_lamp_control/services/repositories/blue_search_repo.dart';
import 'package:rgb_lamp_control/services/services.dart';

class RootScreen extends StatelessWidget {
  RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlueSearchBloc(getIt<BlueSearchRepo>()),
      child: BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
        builder: (context, state) {
          if (state is BlueDeviceConnected) {
            return HomeScreen();
          } else
            return BlueConnectionScreen();
        },
        /* return Scaffold(
            body: ColorPickerView(
              radius: 150,
              thumbRadius: 20,
              colorListener: (color) {
                print(color.toString());
                /*   context.read<RGBModeCubit>().setRGB(
                          redColor: color.red,
                          blueColor: color.blue,
                          greenColor: color.green,
                        ); */
                // must be writen code to send Color to device
              },
            ),
          );}, */
      ),
    );
  }
}
