import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const CustomOutlinedButton(
      {super.key,
      required this.onTap,
      required this.text,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        alignment: Alignment.center,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainFontColor, width: 1.0.w),
          borderRadius: BorderRadius.circular(
            20.r,
          ),
        ),
        child: Text(
          text,
          style: AppTypography.kDescription.copyWith(color: AppColors.mainFontColor
          , fontWeight: FontWeight.w600)
        ),
      ),
    );
  }
}