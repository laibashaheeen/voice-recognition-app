import 'package:Allen/Views/OnBoarding/components/outlined_button.dart';
import 'package:Allen/Views/auth/signin_view.dart';
import 'package:Allen/Views/auth/signup_view.dart';
import 'package:Allen/data/app_assets.dart';
import 'package:Allen/data/app_colors.dart';
import 'package:Allen/data/typography.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FadeInDown(
        duration: const Duration(milliseconds: 1400),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
         
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 350.h,
                width: double.infinity,
                decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.kOnBoarding), fit: BoxFit.fill)),),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Find ",
                    style: AppTypography.kWelcome.copyWith(color: AppColors.mainFontColor),
                    children: [
                      TextSpan(
                        text: "texts, images, voice recognition",
                        style: AppTypography.kOnBoarding.copyWith(fontWeight: FontWeight.w600, color: AppColors.mainFontColor),
                      ),
                      const TextSpan(
                        text: " at one stop",
                        
                      ),
                    ]),
                    ),
              SizedBox(height: 20.h),
              Text(
                "With an extensive information provided by large training models of openAI",
                style: AppTypography.kDescription.copyWith(color: AppColors.mainFontColor, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h,),
              CustomOutlinedButton(
                  onTap: () {
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()),
                        );
                    }
                  },
                  text: 'Register'),
                  SizedBox(height: 20.h,),
              CustomOutlinedButton(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const SigninView())
                );
              }, text: "Login"),
              SizedBox(height: 50.sp),
            ],
          ),
        ),
      ),
    );
}
}