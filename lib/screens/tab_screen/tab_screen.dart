import 'package:flutter/material.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.color_lens), label: 'Colors',),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings',),
        ],
      ),
    );
  }
}
