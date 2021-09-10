import 'package:flutter/material.dart';

import 'package:rgb_lamp_control/util/constants.dart';

enum FireModeSliderType {
  brightness,
  speed,
  min,
}

class FireModeSlider extends StatelessWidget {
  final FireModeSliderType type;
  final void Function(int value) onChange;
  final int? startValue;
  FireModeSlider({
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
    String sliderName = getSliderName();

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
                '$sliderName',
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
      case FireModeSliderType.brightness:
        {
          return 'Brightness';
        }
      case FireModeSliderType.speed:
        {
          return 'Speed';
        }
      case FireModeSliderType.min:
        {
          return 'Min';
        }

      default:
        {
          return '';
        }
    }
  }

  double maxSetup() {
    switch (type) {
      case FireModeSliderType.speed:
        {
          return AppConstants.maxSpeedValue.toDouble();
        }
      default:
        {
          return AppConstants.maxDefaultValue.toDouble();
        }
    }
  }

  Color getActiveColor(int value) {
    switch (type) {
      case FireModeSliderType.brightness:
        {
          return Colors.orange;
        }
      case FireModeSliderType.speed:
        {
          return Colors.cyan;
        }
      case FireModeSliderType.min:
        {
          return Color.fromRGBO(value, 0, 0, 1.0);
        }

      default:
        {
          return Colors.blue;
        }
    }
  }

  double minSetup() {
    switch (type) {
      case FireModeSliderType.brightness:
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
