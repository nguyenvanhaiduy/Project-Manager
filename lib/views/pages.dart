import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/utils/app_constants.dart';
import 'package:project_manager/views/analytics/analytics_screen.dart';
import 'package:project_manager/views/drawer/custom_drawer.dart';
import 'package:project_manager/views/home/home_screen.dart';
import 'package:project_manager/views/projects/project_screen.dart';

class PagesScreen extends StatelessWidget {
  PagesScreen({super.key});

  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      ProjectScreen(),
      const AnalyticsScreen(),
      CustomDrawer(),
    ].obs;

    return Scaffold(
      body: Obx(() => pages[selectedIndex.value]),
      bottomNavigationBar: !GetPlatform.isWeb
          ? Obx(
              () => BottomNavyBar(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? kbackgroundDarkColor
                          : kbackgroundLightColor,
                  items: [
                    BottomNavyBarItem(
                      icon: const Icon(Icons.apps),
                      title: const Text('Home'),
                      activeColor: Colors.red,
                    ),
                    BottomNavyBarItem(
                      icon: const ImageIcon(
                          AssetImage('assets/icons/icons8-project-48.png')),
                      title: const Text('Project'),
                      activeColor: Colors.purpleAccent,
                    ),
                    BottomNavyBarItem(
                      icon: const Icon(Icons.bar_chart),
                      title: const Text('Analytics'),
                      activeColor: Colors.pink,
                    ),
                    BottomNavyBarItem(
                      icon: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      activeColor: Colors.blue,
                    )
                  ],
                  showElevation: true,
                  selectedIndex: selectedIndex.value,
                  onItemSelected: (index) {
                    selectedIndex.value = index;
                  }),
            )
          : null,
    );
  }
}
