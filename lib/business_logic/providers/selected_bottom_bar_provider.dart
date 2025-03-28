import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:bettermint/ui/utils/scaffold_keys.dart';
import 'package:bettermint/ui/widgets/duplicate_dialog.dart';
import 'package:flutter/material.dart';

class SelectedBottomBarProvider extends BaseProvider {
  bool _cancelAction = false;
  bool _successAdded = false;
  bool _successDelete = false;

  setSuccessAdded(bool pSuccess) {
    _successAdded = pSuccess;
  }

  setSuccessDelete(bool pSuccess) {
    _successDelete = pSuccess;
  }

  setCancelAction(bool pCancel) {
    _cancelAction = pCancel;
  }

  // openSelectCollectionBottom(BuildContext context) {
  //   showBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       final theme = Theme.of(context);
  //       return Wrap(
  //         children: [
  //           ListTile(
  //             title: Text("Please choose a collection."),
  //             tileColor: theme.colorScheme.primary,
  //           ),
  //           ListTile(
  //             title: Text("TEST"),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // addCardsToCollection() {
  //   print('Add Card to Collection');
  // }

  hideSnackbar() {
    ScaffoldKeys.mainScaffoldKey.currentState.hideCurrentSnackBar();
  }

  showSnackbar(BuildContext context, String pMsg, Color pColor) {
    final SnackBar customSnackbar = SnackBar(
      content: Text(pMsg),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: pColor,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldKeys.mainScaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldKeys.mainScaffoldKey.currentState.showSnackBar(customSnackbar);
  }

  removeCards(
      MainScaffoldProvider pScaffoldProvider, BuildContext pContext, {bool onCollectionView = false}) async {
    bool selectedDuplicates = false;
    List<CardEntity> deleteCards = pScaffoldProvider
        .getDragController()
        .value
        .selectedIndexes
        .map((e) => pScaffoldProvider.cards.elementAt(e))
        .toList();

    List<CardEntity> duplicateEntities = [];
    List<CardEntity> singleEntities = [];

    deleteCards.forEach(
      (card) {
        if (card.duplicates.length > 1) {
          selectedDuplicates = true;
          duplicateEntities.add(card);
        } else {
          singleEntities.add(card.duplicates.first);
        }
      },
    );

    if (selectedDuplicates) {
      await showDialog(
        context: pContext,
        builder: (BuildContext context) {
          return DuplicateSelectionDialog(
            selectedBottomBarProvider: this,
            duplicateEntities: duplicateEntities,
            delete: true,
            fav: false,
            collection: onCollectionView ? pScaffoldProvider.selectedCollection : null,
          );
        },
      );
    }

    if(!onCollectionView){
      setSuccessDelete((await locator<CardEntityService>()
              .deleteSingleEntities(singleEntities)) >
          0);
    }else{
      CardCollectionService ccs = locator<CardCollectionService>();
      setSuccessDelete(((await ccs.deleteCardsFromCollection(singleEntities, pScaffoldProvider.selectedCollection))> 0));
    }

    if (_successDelete) {
      showSnackbar(pContext, onCollectionView ? "Cards removed from collection" : "Cards successfully deleted.",
          Theme.of(pContext).snackBarTheme.backgroundColor);
    } else {
      showSnackbar(
          pContext, "Failed to remove Cards.", ColorPalette.accent_red);
    }
    pScaffoldProvider.getDragController().clear();

    if(onCollectionView){
      pScaffoldProvider.cardOverviewProvider.initForCollection(pScaffoldProvider.selectedCollection);
    }else{
      pScaffoldProvider.cardOverviewProvider.init();
    }

    setState(ViewState.IDLE);
  }

  cardsToFavourite(MainScaffoldProvider pScaffoldProvider, bool fav,
      BuildContext pContext) async {
    bool selectedDuplicates = false;
    List<CardEntity> favoriteCards = pScaffoldProvider
        .getDragController()
        .value
        .selectedIndexes
        .map((e) => pScaffoldProvider.cards.elementAt(e))
        .toList();

    List<CardEntity> duplicateEntities = [];
    List<CardEntity> singleEntities = [];

    favoriteCards.forEach(
      (card) {
        if (card.duplicates.length > 1) {
          selectedDuplicates = true;
          duplicateEntities.add(card);
        } else {
          singleEntities.add(card.duplicates.first);
        }
      },
    );

    if (selectedDuplicates) {
      await showDialog(
        context: pContext,
        builder: (BuildContext context) {
          return DuplicateSelectionDialog(
            selectedBottomBarProvider: this,
            duplicateEntities: duplicateEntities,
            delete: false,
            fav: fav,
          );
        },
      );
    }

    setSuccessAdded((await locator<CardEntityService>()
            .favCardEntities(singleEntities, fav)) >
        0);

    if (!_cancelAction) {
      if (_successAdded) {
        if (fav) {
          showSnackbar(pContext,"Cards successfully added to Favourites.",
              Theme.of(pContext).snackBarTheme.backgroundColor);
        } else {
          showSnackbar(pContext, "Cards successfully removed from Favourites.",
              Theme.of(pContext).snackBarTheme.backgroundColor);
        }
      } else {
        if (fav) {
          showSnackbar(pContext, "Failed to add Cards to Favourites.",
              ColorPalette.accent_red[300]);
        } else {
          showSnackbar(pContext, "Failed to remove Cards from Favourites.",
              ColorPalette.accent_red[300]);
        }
      }
    } else {
      showSnackbar(pContext, "Action was canceled.",
          Theme.of(pContext).snackBarTheme.backgroundColor);
    }
    //setSuccessAdded(false);
    pScaffoldProvider.getDragController().clear();
    setState(ViewState.IDLE);
  }
}
