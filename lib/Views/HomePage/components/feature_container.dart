
import 'package:ai_app/data/app_colors.dart';
import 'package:ai_app/data/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureContainer extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  const FeatureContainer({
    super.key, required this.color, required this.title, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.all(20.h),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(15.r),
       color: color

     ),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(title,
         style: AppTypography.kHeader.copyWith(color: AppColors.mainFontColor,),),
        SizedBox(height: 5.h),
         Text(description,
         style: AppTypography.kDescription.copyWith(color: AppColors.mainFontColor,),)
       ],
     ),
    );
  }
}