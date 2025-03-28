import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/providers/collection_overview_provider.dart';
import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/enums/view_page_enum.dart';
import 'package:bettermint/ui/screens/main_scaffold.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:bettermint/ui/widgets/base_card_tile.dart';
import 'package:bettermint/ui/widgets/fav_button.dart';
import 'package:flutter/material.dart';

class CollectionTile extends StatelessWidget {
  final MainScaffoldProvider scaffoldProvider;

  final CardCollection collection;
  final CollectionOverviewProvider prov;

  CollectionTile(
      {@required this.prov,
      @required this.collection,
      @required this.scaffoldProvider});

  @override
  Widget build(BuildContext context) {
    var cards = collection.cards;
    return Container(
      height: SCREEN_HEIGHT * 0.18,
      child: InkWell(
        onTap: () {
          scaffoldProvider.selectedCollection = collection;
          scaffoldProvider
              .getPageController()
              .jumpToPage(ViewPage.COLLECTION_DETAIL_VIEW.index - 1);
        },
        child: Stack(
          clipBehavior: Clip.antiAlias,
          fit: StackFit.expand,
          children: [
            Card(
              margin: EdgeInsets.all(0),
              child: Padding(
                padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 11, right: 13),
                            child: Text(
                              collection
                                  .name, //TODO: limit collection name or wrap text
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Spacer(),
                          FavButton(
                              id: collection.id,
                              changeFavStatus: prov.changeFavStatus,
                              isFav: (collection.favorite == null)
                                  ? false
                                  : collection.favorite)
                        ]),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.photo_album,
                                size: 25,
                                color: ColorPalette.cool_grey[300],
                              ),
                              SizedBox(height: SCREEN_HEIGHT * 0.01),
                              Icon(
                                Icons.attach_money,
                                size: 25,
                                color: ColorPalette.cool_grey[300],
                              ),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cards != null ? cards.length.toString() : "0",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(height: SCREEN_HEIGHT * 0.01),
                              Text(
                                  collection.totalValue != null
                                      ? collection.totalValue.toStringAsFixed(2)
                                      : "0",
                                  style: Theme.of(context).textTheme.headline6),
                            ]),
                        Spacer(),
                        cards == null || cards.length == 0
                            ? Container()
                            : Container(
                                height: SCREEN_HEIGHT * 0.087,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      cards.length < 3 ? cards.length : 3,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        child: ShaderMask(
                                            shaderCallback: (rect) {
                                              return LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black,
                                                  Colors.transparent
                                                ],
                                              ).createShader(Rect.fromLTRB(0, 0,
                                                  rect.width, rect.height));
                                            },
                                            blendMode: BlendMode.dstIn,
                                            child: BaseCardTile(
                                              image: prov
                                                  .collectionPreviewImages[
                                                      collection.id]
                                                  .elementAt(index),
                                              tappable: false,
                                            )));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(width: 20),
                                ),
                              ),
                        SizedBox(width: SCREEN_WIDTH * 0.12)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
