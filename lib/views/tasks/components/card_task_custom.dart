import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardTaskCustom extends StatelessWidget {
  const CardTaskCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Get.isDarkMode ? Colors.black26 : Colors.white,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                height: 20,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 6),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '9:00 - 2024-06-01',
                    style: TextStyle(),
                  )
                ],
              ),
            ],
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: Text('In progress'),
          ),
        ],
      ),
    );
  }
}
