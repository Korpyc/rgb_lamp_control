part of 'blue_adapter_cubit.dart';

@immutable
abstract class BlueAdapterState {}

class BlueAdapterInitial extends BlueAdapterState {}

class BlueOnState extends BlueAdapterState {}

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
