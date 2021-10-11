part of 'blue_device_bloc.dart';

abstract class BlueDeviceState {}

class BlueDeviceUnavailable extends BlueDeviceState {}

class BlueDeviceSearching extends BlueDeviceState {}

class BlueDeviceFound extends BlueDeviceState {
  final bool isStillSearching;
  final List<FoundDevice> foundDevices;
  BlueDeviceFound(
    this.foundDevices, {
    this.isStillSearching = false,
  });
}
