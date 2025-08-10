import 'package:fasila/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/bottom_nav_bar_controller.dart';

class CustomBottomNav extends StatelessWidget {
  CustomBottomNav({super.key});

  final BottomNavController bottomNavController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SizedBox(
        height: 65.h,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Material(
            color: Colors.transparent,
            child: BottomNavigationBar(
              currentIndex: bottomNavController.selectedIndex.value,
              onTap: (index) => bottomNavController.changeTabIndex(index),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 24.h),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_sharp, size: 24.h),
                  label: 'Guide',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              iconSize: 24.sp,
              selectedItemColor: AppColor.selected,
              unselectedItemColor: AppColor.unselected,
              selectedLabelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),

        ),
      ),
    ));
  }
}
