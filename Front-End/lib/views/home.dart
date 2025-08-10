import 'package:fasila/views/guide/guide_page.dart';
import 'package:fasila/views/widgets/botnavbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import 'home_page.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.appBar,
            AppColor.background,
          ],
          stops: [0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: CustomBottomNav(),
        body: Obx(() {
          return IndexedStack(
            index: bottomNavController.selectedIndex.value,
            children: [
              HomePage(),
              GuidePage(),
              const Center(
                child: Text('NLP'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
