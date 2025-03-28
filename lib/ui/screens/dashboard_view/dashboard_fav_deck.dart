import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class DasoboardFavDeck extends StatelessWidget {
  final String deckName;
  final double value;
  final Color favColor;

  DasoboardFavDeck(
      {@required this.deckName, @required this.value, @required this.favColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  spreadRadius: 0)
            ],
            border:
                Border.all(width: 0.7, color: ColorPalette.mint_green.shade800),
            color: ColorPalette.cool_grey.shade800),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Row(
              children: [
                Container(
                  child: new Text(deckName,
                      style: Theme.of(context).textTheme.button),
                )
              ],
            ),
            new Container(
              margin: EdgeInsets.only(top: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\€${value.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.subtitle1),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: deckName != "Sonstige"
                              ? favColor
                              : ColorPalette.cool_grey.shade100),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
