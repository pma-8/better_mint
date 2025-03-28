import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/business_logic/providers/selected_bottom_bar_provider.dart';
import 'package:bettermint/enums/view_page_enum.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:flutter/material.dart';

class SelectedBottomBar extends StatelessWidget {
  final MainScaffoldProvider scaffoldProvider;

  SelectedBottomBar({@required this.scaffoldProvider});

  @override
  Widget build(BuildContext context) {
    return BaseView<SelectedBottomBarProvider>(
      onModelReady: (provider) => provider.hideSnackbar(),
      builder: (context, provider, child) => BottomAppBar(
        elevation: 30,
        key: const Key('selecting'),
        child: Container(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //TODO: For future development
              // IconButton(
              //   icon: Icon(Icons.add_circle),
              //   tooltip: 'Add Card to Collection',
              //   onPressed: () {
              //     provider.openSelectCollectionBottom(context);
              //   },
              // ),
              IconButton(
                  icon: Icon(Icons.favorite),
                  tooltip: 'Add Card to Favourites',
                  onPressed: () async => await provider.cardsToFavourite(
                      scaffoldProvider, true, context)),
              IconButton(
                  icon: Icon(Icons.favorite_border),
                  tooltip: 'Remove Card from Favourites',
                  onPressed: () async => provider.cardsToFavourite(
                      scaffoldProvider, false, context)),
              IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: 'Remove Card',
                  onPressed: () async {
                    if(scaffoldProvider.getPageIndex() == ViewPage.CARD_OVERVIEW.index){
                      provider.removeCards(scaffoldProvider, context);
                    }else if(scaffoldProvider.getPageIndex() == ViewPage.COLLECTION_DETAIL_VIEW.index-1){
                      provider.removeCards(scaffoldProvider, context, onCollectionView: true);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
