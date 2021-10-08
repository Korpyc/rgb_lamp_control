import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<BottomNavigationBarItem> _listOfTabs;
  @override
  void initState() {
    super.initState();

    _listOfTabs = [
      BottomNavigationBarItem(
        icon: Icon(Icons.colorize),
        label: 'RGB',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.color_lens),
        label: 'Color',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.fireplace),
        label: 'Fire',
      ),
    ];
  }

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: TextButton(
            child: Text('press'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SomeWidge(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void changeScreenIndex(int index) {
    Future.delayed(
      Duration(microseconds: 1),
      () {
        _selectedIndex.value = index;
      },
    );
  }
}

class SomeWidge extends StatelessWidget {
  const SomeWidge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('data'),
        ),
      ),
    );
  }
}
