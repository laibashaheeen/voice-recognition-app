// import 'dart:convert';

import 'package:Allen/Views/HomePage/homepage.dart';
import 'package:Allen/Views/auth/components/auth_field.dart';
import 'package:Allen/Views/auth/components/primary_button.dart';
import 'package:Allen/Views/auth/components/social_links.dart';
import 'package:Allen/Views/auth/forget_view.dart';
import 'package:Allen/Views/auth/signup_view.dart';
import 'package:Allen/data/app_assets.dart';
import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    // initSharedPref();
  }

  // void initSharedPref() async {
  //   prefs = await SharedPreferences.getInstance();
  // }
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        
          body: SingleChildScrollView(
            
          padding: EdgeInsets.only( top: 130.h, left: 30.w, right: 30.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back!',
                      style: AppTypography.kWelcome.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainFontColor)),
                  SizedBox(height: 30.0.h),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthField(
                              controller: _emailController,
                              hintText: 'Email',
                              icon: AppAssets.kUser),
                          SizedBox(height: 20.h),
                          AuthField(
                              controller: _passwordController,
                              isPassword: true,
                              hintText: 'Password',
                              icon: AppAssets.kLock),
                        ],
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPasswordView()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.kDescription
                              .copyWith(color: AppColors.mainFontColor),
                        )),
                  ),
                  SizedBox(height: 30.h),
                  PrimaryButton(
                      onTap: () {
                        {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          }
                        }
                      },
                      text: 'Login'),
                  SizedBox(height: 30.h),
                  Center(
                    child: Text('- or continue with -',
                        style: AppTypography.kDescription
                            .copyWith(color: AppColors.borderColor)),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialMediaTile(
                        onTap: () {},
                        icon: SvgPicture.asset(AppAssets.kGoogle),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      SocialMediaTile(
                        onTap: () {},
                        icon: SvgPicture.asset(AppAssets.kApple),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      SocialMediaTile(
                        onTap: () {},
                        icon: SvgPicture.asset(
                          AppAssets.kFacebook,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Create an account',
                            style: AppTypography.kDescription
                                .copyWith(color: AppColors.borderColor),
                          ),
                          const TextSpan(text: '  '),
                          TextSpan(
                            text: 'Sign Up',
                            style: AppTypography.kDescription.copyWith(
                              color: AppColors.mainFontColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpView()),
                                );
                              },
                          ),
                        ],
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
