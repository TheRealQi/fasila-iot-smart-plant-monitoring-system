import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors.dart';

class CustomCardPots extends StatelessWidget {
  const CustomCardPots({
    super.key,
    required this.labelText,
    required this.tap,
  });

  final String labelText;
  final Function() tap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175.w,
      height: 110.h,
      child: InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(10.r),
        child: Card(
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          color: Colors.white,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/icons/smart_plant_pot.png",
                      width: 36.w,
                      height: 36.h,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Text(
                      labelText,
                      style: TextStyle(
                        color: AppColor.text,
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
