import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/foundation.dart';
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
      HomeScreen(),
      ProjectScreen(),
      AnalyticsScreen(),
      CustomDrawer(),
    ].obs;

    return Scaffold(
      body: Obx(
        () => Row(
          children: [
            kIsWeb
                ? Container(
                    width: 80,
                    height: 500,
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 10,
                      top: 20,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            selectedIndex.value = 0;
                          },
                          icon: const Icon(
                            Icons.apps,
                            size: 50,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            selectedIndex.value = 1;
                          },
                          icon: const ImageIcon(
                            AssetImage('assets/icons/icons8-project-48.png'),
                            size: 50,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            selectedIndex.value = 2;
                          },
                          icon: const Icon(
                            Icons.bar_chart,
                            size: 50,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            selectedIndex.value = 3;
                          },
                          icon: const Icon(
                            Icons.settings,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: pages[selectedIndex.value],
            )
          ],
        ),
      ),
      bottomNavigationBar: !kIsWeb
          ? Obx(
              () => BottomNavyBar(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? kbackgroundDarkColor
                          : kbackgroundLightColor,
                  items: [
                    BottomNavyBarItem(
                      icon: const Icon(Icons.apps),
                      title: const Text('Dashboard'),
                      activeColor: Colors.red,
                    ),
                    BottomNavyBarItem(
                      icon: const ImageIcon(
                          AssetImage('assets/icons/icons8-project-48.png')),
                      title: Text('Dự án'.tr),
                      activeColor: Colors.purpleAccent,
                    ),
                    BottomNavyBarItem(
                      icon: const Icon(Icons.bar_chart),
                      title: Text('Thống kê'.tr),
                      activeColor: Colors.pink,
                    ),
                    BottomNavyBarItem(
                      icon: const Icon(Icons.settings),
                      title: Text('Cài đặt'.tr),
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
