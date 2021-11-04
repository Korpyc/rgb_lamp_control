part of 'blue_device_bloc.dart';

abstract class BlueDeviceState {}

class BlueDeviceInitial extends BlueDeviceState {}

class BlueDeviceConnected extends BlueDeviceState {
  final bool isLampOn;
  final RgbLampMode mode;
  final dynamic parameters;
  BlueDeviceConnected({
    required this.isLampOn,
    required this.mode,
    required this.parameters,
  });
}

class BlueDeviceDisconnected extends BlueDeviceState {}
