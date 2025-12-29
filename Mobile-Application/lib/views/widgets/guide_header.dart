import 'package:fasila/views/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../colors.dart';
import '../../controllers/search_controller.dart';
import '../guide/search_page.dart';

class GuideHeader extends StatelessWidget {
  GuideHeader({
    super.key,
    required this.body,
  });
  final double appBarHeight = 100.0.h;
  final Widget body;
  final SearchController1 searchController = Get.put(SearchController1());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: appBarHeight,
              width: double.infinity,
              color: Colors.transparent,
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/plant_pot.png",
                          width: 40.w,
                          height: 40.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Guide',
                          style: TextStyle(
                            color: AppColor.text,
                            fontSize: 24.0.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.only(left: 16.w, right: 16.w),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(
            //         child: SizedBox(
            //           height: 40.h,
            //           child: TextField(
            //             controller: searchController.textController,
            //             onTap: () => searchController.isSearching.value = true,
            //             cursorColor: AppColor.primary,
            //             decoration: InputDecoration(
            //               hintText: 'Search for Plants or Diseases',
            //               prefixIcon: const Icon(Icons.search),
            //               prefixIconColor: AppColor.primary,
            //               hoverColor: AppColor.primary,
            //               filled: true,
            //               fillColor: AppColor.search,
            //               border: OutlineInputBorder(
            //                 borderRadius:
            //                     BorderRadius.all(Radius.circular(24.0.r)),
            //                 borderSide: BorderSide.none,
            //               ),
            //               contentPadding: EdgeInsets.symmetric(),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Obx(() {
            //         if (searchController.isSearching.value) {
            //           return Container(
            //             margin: EdgeInsets.only(left: 5.w),
            //             child: CustomIconButton(
            //               tapAction: () {
            //                 searchController.closeSearch();
            //                 FocusScope.of(context).unfocus();
            //               },
            //               icon: Icons.close,
            //             ),
            //           );
            //         } else {
            //           return SizedBox.shrink();
            //         }
            //       })
            //     ],
            //   ),
            // ),
            Expanded(
              child: Obx(() {
                if (searchController.isEditing.value) {
                  return SearchPage(searchController: searchController);
                } else {
                  return body;
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}