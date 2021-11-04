part of 'blue_device_bloc.dart';

abstract class BlueDeviceEvent {}

class BlueDeviceRequestConnect extends BlueDeviceEvent {
  final BluetoothDevice device;
  BlueDeviceRequestConnect(
    this.device,
  );
}

class BlueDeviceUpdateEvent extends BlueDeviceEvent {}

class BlueDeviceDisconnectEvent extends BlueDeviceEvent {}

class BlueDeviceLightSwitchEvent extends BlueDeviceEvent {}

class BlueDeviceModeSwitchEvent extends BlueDeviceEvent {
  final RgbLampMode mode;
  BlueDeviceModeSwitchEvent(this.mode);
}
