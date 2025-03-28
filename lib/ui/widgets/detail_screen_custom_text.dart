import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class DetailScreenCustomText extends StatelessWidget {
  final String title;

  DetailScreenCustomText({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: ColorPalette.cool_grey.shade900,
          fontWeight: FontWeight.w300,
          fontFamily: "Rubik",
          fontStyle: FontStyle.normal,
          fontSize: 18.0),
    );
  }
}
