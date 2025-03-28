import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class DetailScreenTab extends StatelessWidget {
  final String title;

  DetailScreenTab({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
            color: ColorPalette.mint_green,
            fontWeight: FontWeight.w500,
            fontFamily: "Rubik",
            fontStyle: FontStyle.normal,
            fontSize: 18.0),
      ),
    );
  }
}
