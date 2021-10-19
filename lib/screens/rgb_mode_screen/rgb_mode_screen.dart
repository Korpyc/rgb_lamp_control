import 'package:flutter/material.dart';

import 'package:rgb_lamp_control/screens/rgb_mode_screen/widgets/rgb_rounded_picker.dart';

class RgbModeScreen extends StatelessWidget {
  const RgbModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorPickerView(
      radius: 150,
      thumbRadius: 20,
      colorListener: (color) {
        // must be writen code to send Color to device
      },
    );
  }
}
