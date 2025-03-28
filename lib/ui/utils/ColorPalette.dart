import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// https://refactoringui.com/previews/building-your-color-palette/
class ColorPalette {
  static const cool_grey = MaterialColor(0xff616e7c, <int, Color>{
    50: Color(0xfff5f7fa),
    100: Color(0xffe4e7eb),
    200: Color(0xffcbd2d9),
    300: Color(0xff9aa5b1),
    400: Color(0xff7b8794),
    500: Color(0xff616e7c),
    600: Color(0xff52606d),
    700: Color(0xff3e4c59),
    800: Color(0xff323f4b),
    900: Color(0xff1f2933),
    1000: Color(0xFF09151E),
  });

  static const mint_green = MaterialColor(0xFF00CDB3, <int, Color>{
    50: Color(0xFFD6F7F4),
    100: Color(0xFF95EBE0),
    200: Color(0xff1ddecb),
    300: Color(0xFF00CDB3),
    400: Color(0xFF00BEA1),
    500: Color(0xFF00AF8F),
    600: Color(0xFF00A181),
    700: Color(0xFF00906F),
    800: Color(0xFF007F60),
    900: Color(0xFF006241),
  });

  static const accent_blue = MaterialColor(0xFF0672BF, <int, Color>{
    50: Color(0xFFE2F1FA),
    100: Color(0xFFB9DCF4),
    200: Color(0xFF8EC7ED),
    300: Color(0xFF63B0E6),
    400: Color(0xFF41A0E2),
    500: Color(0xFF1D91DE),
    600: Color(0xFF1483D1),
    700: Color(0xFF0672BF),
    800: Color(0xFF0061AD),
    900: Color(0xFF00458F),
  });

  static const accent_red = MaterialColor(0xFFD11229, <int, Color>{
    50: Color(0xFFFFEBEF),
    100: Color(0xFFFFCCD4),
    200: Color(0xFFF5989C),
    300: Color(0xFFED6F75),
    400: Color(0xFFF94B52),
    500: Color(0xFFFF3537),
    600: Color(0xFFF02A37),
    700: Color(0xFFDE1D30),
    800: Color(0xFFD11229),
    900: Color(0xFFC3001C),
  });

  static const accent_purple = MaterialColor(0xFFB200CD, <int, Color>{
    50: Color(0xFFF6E5F9),
    100: Color(0xFFE8BFF0),
    200: Color(0xFFDA93E7),
    300: Color(0xFFCB65DD),
    400: Color(0xFFBE3DD5),
    500: Color(0xFFB200CD),
    600: Color(0xFFA202C7),
    700: Color(0xFF8C00C0),
    800: Color(0xFF7900BA),
    900: Color(0xFF5200B1),
  });

  static const accent_yellow = MaterialColor(0xFFDEDF4D, <int, Color>{
    50: Color(0xFFFBFBE6),
    100: Color(0xFFF5F3C0),
    200: Color(0xFFEDED96),
    300: Color(0xFFE5E66D),
    400: Color(0xFFDEDF4D),
    500: Color(0xFFD9DA2B),
    600: Color(0xFFCBC826),
    700: Color(0xFFB9B21F),
    800: Color(0xFFA79C19),
    900: Color(0xFF89760D),
  });
}
