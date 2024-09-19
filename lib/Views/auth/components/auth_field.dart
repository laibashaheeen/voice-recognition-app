import 'package:Allen/Views/auth/components/validator.dart';
import 'package:Allen/data/app_assets.dart';
import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final String icon;
  const AuthField(
      {super.key,
      required this.controller,
      this.isPassword = false,
      required this.hintText,
      required this.icon});

  @override
  State<AuthField> createState() => _AuthFieldState();
}



class _AuthFieldState extends State<AuthField> {
  bool isObscure = true;

  void _togglePasswordVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? isObscure : false,
      validator: (value) {
        if (widget.isPassword) {
          return CustomValidator.validatePassword(value);
          // String passGen =  generatePassword();
          //                 widget.controller.text = passGen;
          //                 setState(() {
          //                 });
        } else {
          return CustomValidator.validateUsername(value);
        }
        
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: AppColors.borderColor, width: 1.0.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: AppColors.mainFontColor, width: 1.0.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: AppColors.redColor, width: 1.0.w),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide(color: AppColors.redColor, width: 1.0.w),
          ),
          errorStyle: AppTypography.kDescription.copyWith(fontSize: 11.sp,color: AppColors.redColor),
          filled: true,
          
          fillColor: AppColors.borderColor.withOpacity(0.1),
          hintText: widget.hintText,
          hintStyle:
              AppTypography.kDescription.copyWith(color: AppColors.borderColor),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.h),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                      AppColors.borderColor,
                      BlendMode.srcIn,
                    ),
              child: SvgPicture.asset(
                widget.icon,
                
              ),
            ),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      AppColors.borderColor,
                      BlendMode.srcIn,
                    ),
                    child: SvgPicture.asset(
                      isObscure ? AppAssets.kEyeOff : AppAssets.kEye,
                    ),
                  ),
                )
              : null),
    );
  }
}
