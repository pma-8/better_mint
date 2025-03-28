import 'package:bettermint/business_logic/providers/dashboard_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/screens/dashboard_view/dasboard_fav_decks.dart';
import 'package:bettermint/ui/screens/dashboard_view/dashboard_fav_cards.dart';
import 'package:bettermint/ui/screens/dashboard_view/dashboard_total_card.dart';
import 'package:bettermint/ui/screens/main_scaffold.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:bettermint/ui/utils/refresh_snackbar_response.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<DashboardProvider>(
      onModelReady: (provider) => provider.refresh(),
      builder: (context, provider, child) => provider.state == ViewState.BUSY
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                int res = await provider.updatePrices();
                RefreshSnackbarResponse.spawnSnackbar(context, res);
              },
              child: ListView(
                  shrinkWrap: true,
                  children: [
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DashboardTotalCard(
                          provider.totalValue,
                          provider.mostValuableDeckColors,
                          provider.mostValuableDecksPercentages),
                      Text("- Most Valuable Decks - ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    provider.mostValuableDecksAndOther.length > 1 ?
                    DashboardFavDecks(provider.mostValuableDecksAndOther,
                        provider.mostValuableDeckColors) :
                    Container(
                      height: SCREEN_HEIGHT*0.2,
                      child: Card(
                        child: Center(child: Text("Add decks to display the most valuable ones here")),
                      ),
                    ),
                    Text("- Favorite Cards - ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                      DashboardFavCards(provider.favCards)
                    ],
                  ),
                )
              ]),
            ));
  }
}
