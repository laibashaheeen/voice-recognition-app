import 'package:ai_app/data/app_colors.dart';
import 'package:ai_app/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



void main() {

  SystemChrome.setSystemUIOverlayStyle(AppColors.defaultOverlay);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Allen',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(
            useMaterial3: true,).copyWith(
            
            scaffoldBackgroundColor: AppColors.whiteColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.whiteColor
            )
          ),
          scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          home: const HomePage(),
        );
      },
    );
  }
}
