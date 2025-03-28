import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/ui/screens/dashboard_view/dashboard_fav_deck.dart';
import 'package:flutter/material.dart';

class DashboardFavDecks extends StatelessWidget {
  final List<CardCollection> colls;
  final List<Color> colors;

  DashboardFavDecks(this.colls, this.colors);

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 15,
          mainAxisSpacing: 12,
          crossAxisCount: 2,
          childAspectRatio: 2),
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      shrinkWrap: true,
      itemCount: colls.length,
      itemBuilder: (context, index) {
        return DasoboardFavDeck(
          value: colls[index].totalValue,
          favColor: colls[index].name == "Other" ? colors[colors.length-1] : colors[index],
          deckName: colls[index].name,
        );
      },
    );
  }
}
