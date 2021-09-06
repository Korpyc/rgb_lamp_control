part of 'blue_device_bloc.dart';

abstract class BlueDeviceEvent {}

class BlueDeviceConnect extends BlueDeviceEvent {
  final BluetoothDevice device;

  BlueDeviceConnect(this.device);
}

class BlueDeviceUpdate extends BlueDeviceEvent {}

class BlueDeviceSwitchLight extends BlueDeviceEvent {}

class BlueDeviceChangeMode extends BlueDeviceEvent {
  final BlueDeviceMode mode;
  BlueDeviceChangeMode(this.mode);
}
