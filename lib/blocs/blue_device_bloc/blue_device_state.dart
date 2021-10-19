part of 'blue_device_bloc.dart';

abstract class BlueDeviceState {}

class BlueDeviceInitial extends BlueDeviceState {}

class BlueDeviceConnected extends BlueDeviceState {
  final bool isLampOn;
  final RgbLampMode mode;
  BlueDeviceConnected({
    required this.isLampOn,
    required this.mode,
  });
}

class BlueDeviceDisconnected extends BlueDeviceState {}
