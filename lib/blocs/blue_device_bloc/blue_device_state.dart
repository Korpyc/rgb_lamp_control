part of 'blue_device_bloc.dart';

@immutable
abstract class BlueDeviceState {}

class BlueDeviceInitial extends BlueDeviceState {}

class BlueDeviceConnected extends BlueDeviceState {
  final bool isLedEnabled;
  final BlueDeviceMode mode;
  final parameters;
  BlueDeviceConnected({
    required this.isLedEnabled,
    required this.mode,
    required this.parameters,
  });
}
