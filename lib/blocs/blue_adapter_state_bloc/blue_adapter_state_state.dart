part of 'blue_adapter_state_bloc.dart';

abstract class BlueAdapterState {}

class BlueAdapterInitial extends BlueAdapterState {}

class BlueAdapterOnState extends BlueAdapterState {}

class BlueOFFState extends BlueAdapterState {
  @override
  String toString() {
    return 'disabled';
  }
}

class BlueNotAvailableState extends BlueAdapterState {
  @override
  String toString() {
    return 'not supported';
  }
}

class BlueUnauthorizedState extends BlueAdapterState {
  @override
  String toString() {
    return 'no permission garanted';
  }
}

class BlueErrorState extends BlueAdapterState {
  @override
  String toString() {
    return 'broken';
  }
}
