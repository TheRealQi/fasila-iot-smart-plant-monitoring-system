import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors.dart';

class CustomCardDiseases extends StatelessWidget {
  const CustomCardDiseases({
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
    return SizedBox(
      width: 175.w,
      height: 175.h,
      child: InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(10.r),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: EdgeInsets.zero,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: img_url,
                  width: double.infinity,
                  height: 175.h,
                  fit: BoxFit.fill,
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
                      borderRadius: BorderRadius.circular(10.r),
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
        ),
      ),
    );
  }
}
