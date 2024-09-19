import 'package:Allen/Views/auth/components/auth_field.dart';
import 'package:Allen/Views/auth/components/primary_button.dart';
import 'package:Allen/data/app_assets.dart';
import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stylish/data/app_assets.dart';
// import 'package:stylish/data/app_colors.dart';
// import 'package:stylish/data/typography.dart';
// import 'package:stylish/views/auth/components/auth_field.dart';
// import 'package:stylish/views/widgets/buttons/primary_button.dart';

class ForgetPasswordView extends StatelessWidget {
  ForgetPasswordView({super.key});
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                    Navigator.pop(context);
                }, 
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.mainFontColor,)),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20.h, left: 30.w, right: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0.h),
                  child: Text('Forgot password?',
                      style: AppTypography.kWelcome.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainFontColor)),
                ),
                SizedBox(
                  height: 32.0.h,
                ),
                Form(
                  key: _formKey,
                  child: AuthField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: AppAssets.kMail,
                  ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                Text(
                  '* We will send you a message to set or reset your new password',
                  style: AppTypography.kDescription
                      .copyWith(color: AppColors.borderColor),
                ),
                SizedBox(height: 26.h),
                PrimaryButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    text: 'Submit')
              ],
            ),
          )),
    );
  }
}
