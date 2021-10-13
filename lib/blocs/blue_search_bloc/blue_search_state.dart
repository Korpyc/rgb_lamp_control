part of 'blue_search_bloc.dart';

@immutable
abstract class BlueSearchState {}

class BlueDeviceUnavailable extends BlueSearchState {}

class BlueDeviceSearching extends BlueSearchState {}

class BlueDeviceFound extends BlueSearchState {
  final bool isStillSearching;
  final List<FoundDevice> foundDevices;
  BlueDeviceFound(
    this.foundDevices, {
    this.isStillSearching = false,
  });
}
