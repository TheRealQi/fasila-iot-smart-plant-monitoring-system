import 'package:fasila/views/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../colors.dart';

class LightGuide extends StatelessWidget {
  const LightGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      headerText: 'Light Guide',
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(16.w),
                child: Text(
                  'Light is an essential element for plant growth. It is the primary source of energy for photosynthesis, the process by which plants convert light energy, water, and carbon dioxide into glucose and oxygen. Light is also important for plant development and growth. Different plants have different light requirements, so it is important to provide the right amount of light for your plants to thrive.\nThere are 4 main sunlight categories:\n\n1. Full Sun: 6-8 hours of direct sunlight\n2. Partial Sun: 4-6 hours of direct sunlight\n3. Partial Shade: 2-4 hours of direct sunlight\n4. Full Shade: Less than 2 hours of direct sunlight\n\nIn general, most houseplants prefer bright, indirect light. This means placing them near a window where they can get plenty of light, but not direct sunlight. Some plants, like succulents and cacti, prefer full sun, while others, like ferns and snake plants, prefer low light. Be sure to research the light requirements of your plants and place them accordingly.',
                  style: TextStyle(
                    color: AppColor.text,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.w),
                child: Image.asset('assets/images/plantlight.jpg'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
