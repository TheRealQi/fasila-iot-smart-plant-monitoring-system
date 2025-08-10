import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors.dart';

class CustomCardPlants extends StatelessWidget {
  const CustomCardPlants({
    super.key,
    required this.img_url,
    required this.label_text,
    required this.tap,
    required this.sunlight,
    required this.difficulty,
  });

  final String img_url;
  final String label_text;
  final String sunlight;
  final String difficulty;
  final Function() tap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175.w,
      height: 200.h,
      child: InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(10.r),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: img_url,
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                        ),
                      ),
                      width: double.infinity,
                      height: 140.h,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Center(
                        child: SizedBox(
                          height: 140.h,
                          child: Text(
                            'Image not found',
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Text(
                          label_text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.sunny,
                          color: Colors.yellow,
                          size: 24.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          sunlight,
                          style: TextStyle(
                            color: AppColor.text,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          difficulty == "Easy"
                              ? "assets/icons/easy.png"
                              : difficulty == "Medium"
                              ? "assets/icons/medium.png"
                              : "assets/icons/hard.png",
                          width: 24.w,
                          height: 24.h,
                          color: difficulty == "Easy"
                              ? AppColor.primary
                              : difficulty == "Medium"
                              ? Colors.orange
                              : Colors.red,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          difficulty,
                          style: TextStyle(
                            color: AppColor.text,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
