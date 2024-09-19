import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const PrimaryButton(
      {super.key,
      required this.onTap,
      required this.text,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.mainFontColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(text,
            style: AppTypography.kFeature.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 22,
                      )),
      ),
    );
  }
}
