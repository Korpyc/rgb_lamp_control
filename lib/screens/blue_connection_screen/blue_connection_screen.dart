import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';
import 'package:rgb_lamp_control/blocs/blue_search_bloc/blue_search_bloc.dart';
import 'package:rgb_lamp_control/models/found_bluetooth_device.dart';

class BlueConnectionScreen extends StatelessWidget {
  const BlueConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: _buildBody(),
      floatingActionButton: BlocBuilder<BlueSearchBloc, BlueSearchState>(
        builder: (context, state) {
          if (state is BlueDeviceSearching ||
              state is BlueDeviceFound && state.isStillSearching) {
            return Container();
          }
          return FloatingActionButton(
            onPressed: () {
              context.read<BlueSearchBloc>().add(BlueDeviceStartScanEvent());
            },
            child: Icon(Icons.search),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: BlocBuilder<BlueSearchBloc, BlueSearchState>(
              builder: (context, state) {
                if (state is BlueDeviceSearching) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is BlueDeviceUnavailable) {
                  return Center(
                    child: Text(
                      'Press search button to find Lamp',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                if (state is BlueDeviceFound) {
                  return _buildListOfDevices(state);
                }
                return Center(
                  child: Text('Devices not found'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        elevation: 6,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Found devices:',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListOfDevices(BlueDeviceFound state) {
    return ListView.separated(
      itemCount: state.foundDevices.length,
      itemBuilder: (context, index) {
        if (index + 1 == state.foundDevices.length && state.isStillSearching) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDeviceItem(
                foundDevice: state.foundDevices[index],
                context: context,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }
        return _buildDeviceItem(
          foundDevice: state.foundDevices[index],
          context: context,
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _buildDeviceItem({
    required FoundDevice foundDevice,
    required BuildContext context,
  }) {
    return Card(
      child: ListTile(
        title: Text(
          foundDevice.deviceName,
        ),
        trailing: _buildConnectionButton(
          () {
            context.read<BlueDeviceBloc>().add(
                  BlueDeviceRequestConnect(
                    foundDevice.device,
                  ),
                );
          },
        ),
      ),
    );
  }

  Widget _buildConnectionButton(VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text('CONNECT'),
      color: Colors.black,
      textColor: Colors.white,
    );
  }
}
