import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static const int _primaryColor = 0xFF3D6E99;
  static const int _secondaryColor = 0xFFFFAA13;

  static MaterialColor primaryColor = const MaterialColor(
    _primaryColor,
    <int, Color>{
      50: Color(0xFFE0E8F0),
      100: Color(0xFFB3C9DE),
      200: Color(0xFF85A9CC),
      300: Color(0xFF5789BA),
      400: Color(0xFF2F6FAE),
      500: Color(_primaryColor),
      600: Color(0xFF2A5D8A),
      700: Color(0xFF1F4B6A),
      800: Color(0xFF15394A),
      900: Color(0xFF0B2530),
    },
  );

  static MaterialColor secondaryColor = const MaterialColor(
    _secondaryColor,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(_secondaryColor),
      600: Color(0xFFE68A00),
      700: Color(0xFFD97600),
      800: Color(0xFFC66300),
      900: Color(0xFFB25000),
    },
  );

  static MaterialColor neutralColor = const MaterialColor(
    _primaryNeutralValue,
    <int, Color>{
      50: Color(_baseWhiteValue),
      100: Color(0xFFE3E3E3),
      200: Color(0xFFCCCBCB),
      300: Color(0xFFB5B3B3),
      400: Color(0xFF9F9C9C),
      500: Color(0xFF898384),
      600: Color(_primaryNeutralValue),
      700: Color(0xFF5A5555),
      800: Color(0xFF433E3F),
      900: Color(0xFF2B2829),
      1000: Color(0xFF151314),
      1100: Color(_baseBlackValue),
    },
  );
  static const int _primaryNeutralValue = 0xFF726C6C;
  static const int _baseBlackValue = 0xFF27252E;
  static const int _baseWhiteValue = 0xFFFAFAFA;

  static const Color baseBlackColor = Color(_baseBlackValue);
  static const Color baseWhiteColor = Color(_baseWhiteValue);
  static const Color primaryBlackColor = Color(0xFF333333);
  static const Color primaryWhiteColor = Color(0xFFFCFCFC);
  static const Color secondaryBlackColor = Color(0xFF484C52);
  static const Color secondaryWhiteColor = Color(0xFFF7F7F7);
  static const Color lightPrimaryColor = Color(0xFF4E96C6);

  static const Color primaryGreyColor = Color(0xFF8B8B8B);
  static const Color secondaryGreyColor = Color(0xFF6F6F6F);
  static const Color greyColor = Color(0xFF737373);
  static const Color lightGreyColor = Color(0xFFD2D2D2);
  static const Color blackGreyColor = Color(0xFF818181);

  static const Color borderWhiteGreyColor = Color(0xFFD2D5DA);
  static const Color lightBlueColor = Color(0xFF93C5FD);
  static const Color borderColor = Color(0xFF8E8E8E);

  static const Color firstLinearColor = Color(0xFF113295);
  static const Color secondLinearColor = Color(0xFF5F8FA9);

  static const Color shadowWhiteColor = Color(0x12000000);

  static const Color greyTextColor = Color(0xFF4F4F4F);
  static const Color backgroundColor = Color(0xFFFFF9E9);

  static MaterialColor successColor = const MaterialColor(
    _primarySuccessValue,
    <int, Color>{
      100: Color(_primarySuccessValue),
      200: Color(0xFF15B097),
      300: Color(0xFF0B7B69),
    },
  );
  static const int _primarySuccessValue = 0xFFA4F4E7;

  static MaterialColor warningColor = const MaterialColor(
    _primaryWarningValue,
    <int, Color>{
      100: Color(_primaryWarningValue),
      200: Color(0xFFEDA145),
      300: Color(0xFFCC7914),
    },
  );
  static const int _primaryWarningValue = 0xFFF4C790;

  static MaterialColor errorColor = const MaterialColor(
    _primaryErrorValue,
    <int, Color>{
      100: Color(_primaryErrorValue),
      200: Color(0xFFC03744),
      300: Color(0xFF8C1823),
    },
  );
  static const int _primaryErrorValue = 0xFFFF9D9D;
}
