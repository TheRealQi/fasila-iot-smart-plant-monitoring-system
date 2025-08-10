import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors.dart';

class CustomIconButton extends StatelessWidget {
  final GestureTapCallback tapAction;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final EdgeInsets margin;

  const CustomIconButton({
    super.key,
    required this.tapAction,
    required this.icon,
    this.margin = EdgeInsets.zero,
    this.bgColor = AppColor.icon_bg,
    this.iconColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(15.r),
      child: InkWell(
        onTap: tapAction,
        borderRadius: BorderRadius.circular(15.r),
        child: Container(
          width: 40.w,
          height: 40.h,
          margin: margin,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24.w,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
