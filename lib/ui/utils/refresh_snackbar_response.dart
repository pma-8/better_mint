import 'package:bettermint/ui/screens/main_scaffold.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class RefreshSnackbarResponse{
  static spawnSnackbar(BuildContext context ,int res){
    Color backgroundColor;
    Text text;
    backgroundColor = Theme.of(context).snackBarTheme.backgroundColor;
    double width = SCREEN_WIDTH*0.5;
    if(res > 0){
      text = Text("Updated Prices!",
          textAlign: TextAlign.center);
    }else if(res == 0){
      text = Text("Prices Already Up To Date",
        textAlign: TextAlign.center,);
    }else{
      text = Text("Error Updating Prices",
          textAlign: TextAlign.center);
      backgroundColor = ColorPalette.accent_red[300];
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: backgroundColor,
        content: text,
        width: width,
        behavior: SnackBarBehavior.floating));
  }
}