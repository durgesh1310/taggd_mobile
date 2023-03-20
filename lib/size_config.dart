import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  static double _safeAreaHorizontal = 0;
  static double _safeAreaVertical = 0;
  static double safeBlockHorizontal = 0;
  static double safeBlockVertical = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      screenWidth = _mediaQueryData!.size.width;
      screenHeight = _mediaQueryData!.size.height;
      isPortrait = true;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      screenWidth = _mediaQueryData!.size.height;
      screenHeight = _mediaQueryData!.size.width;
      isPortrait = false;
      isMobilePortrait = false;
    }
    _blockWidth = screenWidth / 100;
    _blockHeight = screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    _safeAreaHorizontal = _mediaQueryData!.padding.left +
        _mediaQueryData!.padding.right;
    _safeAreaVertical = _mediaQueryData!.padding.top +
        _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth -
        _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight -
        _safeAreaVertical) / 100;
  }
}

/*File for making the app more responsive */
