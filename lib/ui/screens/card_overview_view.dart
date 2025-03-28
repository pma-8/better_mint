import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/providers/card_overview_provider.dart';
import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/business_logic/utils/sort_service.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/screens/collection_overview_view/collection_add_card_view.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:bettermint/ui/utils/refresh_snackbar_response.dart';
import 'package:bettermint/ui/widgets/card_tile.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_scaffold.dart';

class CardOverviewView extends StatefulWidget {
  final MainScaffoldProvider scaffoldProvider;
  final CardCollection
      collection; //// set this parameter if card collection details should be displayed

  CardOverviewView({@required this.scaffoldProvider, this.collection});

  @override
  State<StatefulWidget> createState() => CardOverviewViewState(
      scaffoldProvider: scaffoldProvider, collection: collection);
}

class CardOverviewViewState extends State<CardOverviewView> {
  final MainScaffoldProvider scaffoldProvider;
  final CardCollection collection;

  CardOverviewViewState({@required this.scaffoldProvider, this.collection});

  @override
  Widget build(BuildContext context) {
    return BaseView<CardOverviewProvider>(
      onModelDispose: (provider) {
        scaffoldProvider.cardOverviewProvider = null;
        scaffoldProvider.searchQueryController.removeListener(() =>
            filterSearchResults(
                scaffoldProvider.searchQueryController.value.text, provider));
        provider.sortService
            .removeListener(() => _sortIfMounted(true, provider));
      },
      onModelReady: (provider) async {
        if (collection == null) {
          await provider.init();
        } else {
          await provider.initForCollection(collection);
        }
        provider.sortService.addListener(() {
          _sortIfMounted(true, provider);
        });
        scaffoldProvider.searchQueryController.addListener(() =>
            filterSearchResults(
                scaffoldProvider.searchQueryController.value.text, provider));
        _sortIfMounted(true, provider);
        print("update provider");
        scaffoldProvider.cardOverviewProvider = provider;
      },
      builder: (context, provider, child) => provider.state == ViewState.BUSY
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                int res = await provider.refresh();
                RefreshSnackbarResponse.spawnSnackbar(context, res);
              },
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: collection == null
                      ? _buildGridForCardOverview(provider)
                      : _buildGridForCollectionOverview(provider)),
            ),
    );
  }

  Widget _buildGridForCollectionOverview(CardOverviewProvider provider) {
    scaffoldProvider.setCards(provider.cards);
    return Stack(children: [
      DragSelectGridView(
        shrinkWrap: true,
        gridController: scaffoldProvider.getDragController(),
        scrollController: scaffoldProvider.getScrollViewController(),
        itemCount: provider.cards.length,
        itemBuilder: (context, index, selected) {
          return CardTile(
            key: UniqueKey(),
            priceChange: "",
            image: provider.cards[index].image,
            entity: provider.cards[index],
            lost: true,
            selected: selected,
            selection: scaffoldProvider.getDragController().value,
          );
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          childAspectRatio: 1 / 1.4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: SCREEN_HEIGHT*0.08, right: SCREEN_WIDTH*0.01),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: 'addFloatingButton',
            mini: true,
            onPressed: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                  builder: (BuildContext context) {
                  return CollectionAddCardView(coll: collection,);
                  }
              ).whenComplete(() async {
                await provider.initForCollection(collection);
                _sortIfMounted(false, provider);
              });
            },
            child: Icon(
              Icons.add_rounded,
              size: SCREEN_WIDTH * 0.09,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildGridForCardOverview(CardOverviewProvider provider) {
    scaffoldProvider.setCards(provider.cards);
    return DragSelectGridView(
      shrinkWrap: true,
      gridController: scaffoldProvider.getDragController(),
      scrollController: scaffoldProvider.getScrollViewController(),
      itemCount: provider.cards.length,
      itemBuilder: (context, index, selected) {
        return CardTile(
          priceChange: "",
          image: provider.cards[index].image,
          entity: provider.cards[index],
          lost: true,
          selected: selected,
          selection: scaffoldProvider.getDragController().value,
        );
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 1 / 1.4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }

  void filterSearchResults(String query, CardOverviewProvider prov) {
    List<CardEntity> dummySearchList = List();
    dummySearchList.addAll(prov.cardsDuplicate);

    if (query.isNotEmpty) {
      List<CardEntity> dummyListData = List();
      dummySearchList.forEach((entry) {
        String toQuery =
            entry.setCode + " " + entry.setCodeInformation.cardInformation.name;
        if (toQuery.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(entry);
        }
      });
      prov.cards.clear();
      prov.cards.addAll(dummyListData);
    } else {
      prov.cards.clear();
      prov.cards.addAll(prov.cardsDuplicate);
    }
    _sortIfMounted(false, prov);
  }

  sort({bool alterDuplicates = true, CardOverviewProvider provider}) {
    switch (provider.sortService.getSortedBy(scaffoldProvider.getPageIndex())) {
      case SortedBy.dateAdded:
        provider.cards.sort((a, b) {
          DateTime aDateTime = DateTime.parse(a.latestCreateTime);
          DateTime bDateTime = DateTime.parse(b.latestCreateTime);
          return bDateTime.compareTo(aDateTime);
        });
        break;
      case SortedBy.alphabetical:
        provider.cards.sort((a, b) {
          return a.setCodeInformation.cardInformation.name
              .compareTo(b.setCodeInformation.cardInformation.name);
        });
        break;
      case SortedBy.marketValue:
        provider.cards.sort((a, b) {
          return b.setCodeInformation.setPrice.averagePrice
              .compareTo(a.setCodeInformation.setPrice.averagePrice);
        });
        break;
      case SortedBy.favorite:
        provider.cards.sort((a, b) {
          return a.favorite ? -1 : 1;
        });
    }
    if (alterDuplicates) {
      provider.cardsDuplicate.clear();
      provider.cardsDuplicate.addAll(provider.cards);
    }
  }

  _sortIfMounted(bool alterDuplicates, CardOverviewProvider provider) {
    if (mounted) {
      setState(() {
        sort(alterDuplicates: alterDuplicates, provider: provider);
      });
    }
  }
}
