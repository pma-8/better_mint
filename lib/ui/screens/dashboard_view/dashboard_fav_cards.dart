import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/ui/widgets/base_card_tile.dart';
import 'package:flutter/material.dart';

class DashboardFavCards extends StatelessWidget {
  final List<CardEntity> favCardsInfo;

  DashboardFavCards(this.favCardsInfo);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ///  Text( TODO: the cards look too small when heart symbol is added
            ///    "♥"
            ///  ),
            Expanded(
              child: favCardsInfo.isNotEmpty ? ListView.separated(
                padding: EdgeInsets.all(10),
                addAutomaticKeepAlives: true,
                itemCount: favCardsInfo.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext ctxt, int index) =>
                    _buildCard(ctxt, index, favCardsInfo),
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 20,
                  );
                },
              ): Center(child: Text("No Favorite Cards :(",
                style: Theme.of(context).textTheme.bodyText1,
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, int index, List<CardEntity> cards) {
    return BaseCardTile(image: cards[index].image, entity: cards[index]);
  }
}
