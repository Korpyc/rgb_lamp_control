import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rgb_lamp_control/blocs/blue_device_bloc/blue_device_bloc.dart';

class BlueConnectionScreen extends StatelessWidget {
  const BlueConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
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
            ),
            Expanded(
              child: BlocBuilder<BlueDeviceBloc, BlueDeviceState>(
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
                    return ListView.separated(
                      itemCount: state.foundDevices.length,
                      itemBuilder: (context, index) {
                        if (index + 1 == state.foundDevices.length &&
                            state.isStillSearching) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    state.foundDevices[index].deviceName,
                                  ),
                                  trailing: MaterialButton(
                                    onPressed: () {},
                                    child: Text('CONNECT'),
                                    color: Colors.black,
                                    textColor: Colors.white,
                                  ),
                                ),
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
                        return Card(
                          child: ListTile(
                            title: Text(
                              state.foundDevices[index].deviceName,
                            ),
                            subtitle: Text(state.foundDevices[index].uuid),
                            trailing: MaterialButton(
                              onPressed: () {},
                              child: Text('CONNECT'),
                              color: Colors.black,
                              textColor: Colors.white,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    );
                  }
                  return Center(
                    child: Text('Devices not found'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              context.read<BlueDeviceBloc>().add(BlueDeviceStartScanEvent());
            },
            child: Icon(Icons.search),
          );
        },
      ),
    );
  }
}
