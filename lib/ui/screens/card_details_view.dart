import 'dart:ui';

import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/providers/card_details_provider.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:bettermint/ui/utils/card_details_sliver_app_bar_delegate.dart';
import 'package:bettermint/ui/widgets/detail_screen_card_details.dart';
import 'package:bettermint/ui/widgets/detail_screen_market_details.dart';
import 'package:bettermint/ui/widgets/detail_screen_owned_card.dart';
import 'package:flutter/material.dart';

class CardDetailsView extends StatelessWidget {
  final ImageProvider image;
  final CardEntity cardEntity;

  CardDetailsView({
    @required this.image,
    @required this.cardEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<CardDetailsProvider>(
      builder: (context, provider, child) => SafeArea(
        child: Scaffold(
          body: DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.width / 1.4,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Text(
                              cardEntity
                                  .setCodeInformation.cardInformation.name,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                      ),
                      background: Image(
                        fit: BoxFit.fitWidth,
                        image: image,
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: CardDetailsSliverAppBarDelegate(
                      tabBar: TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        //TODO: Themdata irgendwie einbinden
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                            text: "Owned Cards",
                          ),
                          Tab(
                            text: "Market Details",
                          ),
                          Tab(
                            text: "Card Details",
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DetailScreenOwnedCard(
                    tileBuilder: provider.createOwnedCardsList(cardEntity),
                  ),
                  DetailScreenMarketDetails(
                    tileBuilder: provider.createMarketList(cardEntity),
                  ),
                  DetailScreenCardDetails(
                    tileBuilder: provider.createInfoList(cardEntity),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
