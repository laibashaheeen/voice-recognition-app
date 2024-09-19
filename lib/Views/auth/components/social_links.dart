import 'package:Allen/data/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialMediaTile extends StatelessWidget {
  const SocialMediaTile({required this.onTap, required this.icon, super.key});
  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        width: 60.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.borderColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(100),
          
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}