import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors.dart';

class CustomCardDiseasesHorizontal extends StatelessWidget {
  const CustomCardDiseasesHorizontal({
    super.key,
    required this.img_url,
    required this.tap,
    required this.label_text,
  });

  final String img_url;
  final String label_text;
  final Function() tap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SizedBox(
            height: 100.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Disease Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: img_url,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                          ),
                        ),
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade300,
                      width: 100.w,
                      height: 100.h,
                      child: Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(
                            color: AppColor.text,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                // Spacer
                SizedBox(width: 10.w),
                // Disease Name
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label_text,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
