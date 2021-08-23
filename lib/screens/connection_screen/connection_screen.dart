import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  ValueNotifier<bool> _isUnNamedShown = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 32),
              alignment: Alignment.center,
              child: Text(
                'Bluetooth setup',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Text('Find Devices'),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<List<ScanResult>>(
                        stream: FlutterBlue.instance.scanResults,
                        initialData: [],
                        builder: (c, snapshot) {
                          if (snapshot.hasData) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: _isUnNamedShown,
                              builder: (context, value, child) {
                                List<Widget> listOfDevices = [];
                                for (dynamic elem in snapshot.data!) {
                                  if (!value) {
                                    if (elem.advertisementData.connectable &&
                                        elem.device.name.length >= 1) {
                                      listOfDevices.add(
                                        ScanResultTile(
                                          result: elem,
                                          onTap: () {},
                                        ),
                                      );
                                    }
                                  } else {
                                    listOfDevices.add(
                                      ScanResultTile(
                                        result: elem,
                                        onTap: () {},
                                      ),
                                    );
                                  }
                                }
                                if (listOfDevices.length >= 1) {
                                  return Column(
                                    children: listOfDevices,
                                  );
                                } else
                                  return Container(
                                    child: Text(
                                      'No devices was found',
                                    ),
                                  );
                              },
                            );
                          }
                          return Container(
                            child: Text(
                              'No devices was found',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isUnNamedShown,
              builder: (context, value, child) => CheckboxListTile(
                value: _isUnNamedShown.value,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  if (value != null) {
                    _isUnNamedShown.value = value;
                  }
                },
                title: Text('Show unnamed devices'),
              ),
            )
          ],
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () => FlutterBlue.instance.startScan(
                        scanMode: ScanMode.lowPower,
                        timeout: Duration(seconds: 4),
                      ));
            }
          },
        ),
      ),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      trailing: MaterialButton(
        child: Text('CONNECT'),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: onTap,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }
}
