import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt _selectedIndex = 0.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: Obx(
        () => BottomNavyBar(
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.apps),
                title: const Text('Home'),
                activeColor: Colors.red,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.people),
                title: const Text('Home'),
                activeColor: Colors.purpleAccent,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.message),
                title: const Text('Home'),
                activeColor: Colors.pink,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.settings),
                title: const Text('Home'),
                activeColor: Colors.blue,
              )
            ],
            showElevation: true,
            selectedIndex: _selectedIndex.value,
            onItemSelected: (index) {
              _selectedIndex.value = index;
            }),
      ),
    );
  }
}
