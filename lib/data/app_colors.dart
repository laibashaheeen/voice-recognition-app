import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color mainFontColor = Color.fromRGBO(19, 61, 95, 1);
  static const Color firstSuggestionBoxColor = Color.fromRGBO(201, 187, 207, 1.0); 
  static const Color secondSuggestionBoxColor = Color.fromRGBO(183, 211, 223, 1.0); 

  static const Color thirdSuggestionBoxColor = Color.fromRGBO(226, 191, 179, 1.0); 
  static const Color assistantCircleColor = Color.fromRGBO(214, 239, 237, 1.0); 
  static const Color borderColor = Color.fromRGBO(200, 200, 200, 1);
  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;
   static const Color redColor = Colors.red;

  static const defaultOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
}
