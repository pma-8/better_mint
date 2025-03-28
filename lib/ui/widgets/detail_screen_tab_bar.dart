import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:bettermint/ui/widgets/detail_screen_tab.dart';
import 'package:flutter/material.dart';

class DetailScreenTabBar extends StatelessWidget {
  final CardEntity cardEntity;

  DetailScreenTabBar({@required this.cardEntity});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 2,
      child: SizedBox(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: TabBar(
                  tabs: [
                    DetailScreenTab(title: "CARD DETAILS"),
                    DetailScreenTab(title: "MARKET DETAILS"),
                  ],
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(color: ColorPalette.cool_grey.shade300),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(
                  children: [
                    //DetailScreenCardDetails(cardEntity: cardEntity),
                    //DetailScreenMarketDetails(),
                  ],
                ), // Complete this code in the next step.
              )
            ],
          ),
        ),
      ),
    );
  }
}
