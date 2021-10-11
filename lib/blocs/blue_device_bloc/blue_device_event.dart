part of 'blue_device_bloc.dart';

abstract class BlueDeviceEvent {}

class BlueDeviceStartScanEvent extends BlueDeviceEvent {}

class BlueDeviceUpdateEvent extends BlueDeviceEvent {}
