import 'package:flutter/material.dart';

import 'package:rgb_lamp_control/util/constants.dart';

enum ColorPickerSliderType { brightness, white, red, green, blue, color }

class ColorPickerSlider extends StatelessWidget {
  final ColorPickerSliderType type;
  final void Function(int value) onChange;
  final int? startValue;
  ColorPickerSlider({
    required this.type,
    required this.onChange,
    this.startValue,
    Key? key,
  }) : super(key: key) {
    currentValue = ValueNotifier(startValue ?? minSetup().round());
  }

  late final ValueNotifier<int> currentValue;

  @override
  Widget build(BuildContext context) {
    String colorName = getSliderName();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: getActiveColor(255),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Text(
                '$colorName color',
                style: TextStyle(fontSize: 24, color: getActiveColor(255)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: currentValue,
                  builder: (context, value, child) => Slider(
                    activeColor: getActiveColor(value),
                    value: value.toDouble(),
                    onChanged: (value) {
                      onChange(value.round());
                      currentValue.value = value.round();
                    },
                    min: minSetup(),
                    max: maxSetup(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getSliderName() {
    switch (type) {
      case ColorPickerSliderType.brightness:
        {
          return 'Brightness';
        }
      case ColorPickerSliderType.white:
        {
          return 'White';
        }
      case ColorPickerSliderType.red:
        {
          return 'Red';
        }
      case ColorPickerSliderType.blue:
        {
          return 'Blue';
        }
      case ColorPickerSliderType.green:
        {
          return 'Green';
        }
      case ColorPickerSliderType.color:
        {
          return 'Choose';
        }
      default:
        {
          return '';
        }
    }
  }

  double maxSetup() {
    switch (type) {
      case ColorPickerSliderType.color:
        {
          return AppConstants.maxNumberOfColorValue.toDouble();
        }
      default:
        {
          return AppConstants.maxDefaultValue.toDouble();
        }
    }
  }

  Color getActiveColor(int value) {
    switch (type) {
      case ColorPickerSliderType.brightness:
        {
          return Colors.orange;
        }
      case ColorPickerSliderType.white:
        {
          return Colors.cyan;
        }
      case ColorPickerSliderType.red:
        {
          return Color.fromRGBO(value, 0, 0, 1.0);
        }
      case ColorPickerSliderType.green:
        {
          return Color.fromRGBO(0, value, 0, 1.0);
        }
      case ColorPickerSliderType.blue:
        {
          return Color.fromRGBO(0, 0, value, 1.0);
        }

      default:
        {
          return Colors.blue;
        }
    }
  }

  double minSetup() {
    switch (type) {
      case ColorPickerSliderType.brightness:
        {
          return AppConstants.minBrightnessValue.toDouble();
        }
      default:
        {
          return AppConstants.minDefaultValue.toDouble();
        }
    }
  }
}
