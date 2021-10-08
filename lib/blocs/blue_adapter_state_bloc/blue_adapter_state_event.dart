part of 'blue_adapter_state_bloc.dart';

abstract class BlueAdapterEvent {}

class BlueAdapterUpdateEvent extends BlueAdapterEvent {
  final BluetoothState blueAdapterState;
  BlueAdapterUpdateEvent(this.blueAdapterState);
}
