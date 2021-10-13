part of 'blue_search_bloc.dart';

@immutable
abstract class BlueSearchEvent {}

class BlueDeviceStartScanEvent extends BlueSearchEvent {}

class BlueDeviceUpdateEvent extends BlueSearchEvent {}
