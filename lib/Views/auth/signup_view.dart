import 'package:Allen/Views/HomePage/homepage.dart';
import 'package:Allen/Views/auth/components/auth_field.dart';
import 'package:Allen/Views/auth/components/primary_button.dart';
import 'package:Allen/Views/auth/components/social_links.dart';
import 'package:Allen/Views/auth/signin_view.dart';
import 'package:Allen/data/app_assets.dart';
import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 130.h, left: 30.w, right: 30.w),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create an account',
                      style: AppTypography.kWelcome.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainFontColor),),
                  SizedBox(
                    height: 30.0.h,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthField(
                              controller: _emailController,
                              hintText: 'Email',
                              icon: AppAssets.kUser),
                          SizedBox(
                            height: 20.h,
                          ),
                          AuthField(
                              controller: _passwordController,
                              isPassword: true,
                              hintText: 'Password',
                              icon: AppAssets.kLock),
                          SizedBox(
                            height: 20.h,
                          ),
                          AuthField(
                              controller: _confirmPasswordController,
                              isPassword: true,
                              hintText: 'Confirm Password',
                              icon: AppAssets.kLock),
                        ],
                      )),
                  SizedBox(
                    height: 30.h,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'By clicking the ',
                          style: AppTypography.kDescription
                              .copyWith(color: AppColors.borderColor, height: 1.5.h),
                        ),
                        TextSpan(
                          text: 'Register ',
                          style: AppTypography.kDescription.copyWith(
                            color: AppColors.mainFontColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        TextSpan(
                          text: 'button, you agree to the public offer',
                          style: AppTypography.kDescription
                              .copyWith(color: AppColors.borderColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  PrimaryButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                    "Passwords do not match",
                                    style: AppTypography.kDescription.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.mainFontColor),
                                  ),
                                  backgroundColor: AppColors.borderColor),
                            );
                          } else {
                            // Passwords match, proceed with account creation
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          }
                        }
                      },
                      text: 'Register'),
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
                            text: 'I already have an account',
                            style: AppTypography.kDescription
                                .copyWith(color: AppColors.borderColor),
                          ),
                          const TextSpan(text: '  '),
                          TextSpan(
                            text: 'Login',
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
                                      builder: (context) => const SigninView()),
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
