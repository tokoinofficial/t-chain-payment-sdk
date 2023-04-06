import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class TextStyles {
  static const TextStyle headline = TextStyle(
    letterSpacing: -0.41,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle body1 = TextStyle(
    letterSpacing: -0.41,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    letterSpacing: -0.41,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const TextStyle subhead1 = TextStyle(
    letterSpacing: -0.24,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 22.5 / 15,
    fontFamily: 'SF Pro Text',
  );

  static const TextStyle subhead2 = TextStyle(
    letterSpacing: -0.24,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const TextStyle subhead3 = TextStyle(
    letterSpacing: -0.24,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const TextStyle subhead4 = TextStyle(
    letterSpacing: -0.08,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.65,
  );

  static const TextStyle footnote = TextStyle(
    letterSpacing: -0.08,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.65,
  );

  static const TextStyle caption1 = TextStyle(
    letterSpacing: -0.0062,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.65,
  );

  static const TextStyle caption2 = TextStyle(
    letterSpacing: -0.5,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.75,
  );

  static const TextStyle caption3 = TextStyle(
    letterSpacing: -0.012,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.75,
  );

  static const TextStyle caption4 = TextStyle(
    letterSpacing: -0.005,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.75,
  );

  static const TextStyle largeTitle = TextStyle(
    letterSpacing: 0.4,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  static const TextStyle title1 = TextStyle(
    letterSpacing: 0.34,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static const TextStyle title2 = TextStyle(
    letterSpacing: 0.35,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  static const TextStyle helpText = TextStyle(
    letterSpacing: 0.35,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );
}
