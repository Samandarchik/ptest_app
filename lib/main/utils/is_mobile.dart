import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveManager {
  static DeviceType deviceType = DeviceType.mobile;
  static double screenWidth = 0;
  static double screenHeight = 0;

  // INIT qilish: constraints + MediaQuery
  static void init(BoxConstraints constraints, BuildContext context) {
    screenWidth = constraints.maxWidth;
    screenHeight = constraints.maxHeight;

    // device type aniqlash
    if (screenWidth < 600) {
      deviceType = DeviceType.mobile;
    } else if (screenWidth < 1100) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.desktop;
    }
  }

  // UNIVERSAL SWITCH-CASE
  static T pick<T>({required T mobile, required T tablet, required T desktop}) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }

  // OPTIONAL: MediaQuery scale bilan width/height hisoblash
  static double width(double mobile, double tablet, double desktop) {
    return pick(
      mobile: screenWidth * mobile,
      tablet: screenWidth * tablet,
      desktop: screenWidth * desktop,
    );
  }

  static double height(double mobile, double tablet, double desktop) {
    return pick(
      mobile: screenHeight * mobile,
      tablet: screenHeight * tablet,
      desktop: screenHeight * desktop,
    );
  }
}
