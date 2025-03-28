import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class DuplicateDialogProvider extends BaseProvider {
  List<List<bool>> checked = [[]];
  List<CardEntity> checkedEntities = [];

  String createSubTitle(CardEntity card) {
    String subTitle = "";

    if (card.favorite != null) {
      subTitle += card.favorite ? "Favored" : "";

      if (card.favorite &&
          ((card.condition != null && card.condition.isNotEmpty) ||
              card.firstEdition != null && card.firstEdition)) {
        subTitle += " | ";
      }
    }

    if (card.condition != null && card.condition.isNotEmpty) {
      subTitle += card.condition + " ";

      if (card.firstEdition != null && card.firstEdition) {
        subTitle += " | ";
      }
    }

    if (card.firstEdition != null) {
      subTitle += card.firstEdition ? "First Edition" + " " : "";
    }

    return subTitle;
  }

  Future<int> favDuplicates(
    List<CardEntity> cards,
    bool fav,
  ) async {
    return await locator<CardEntityService>()
        .favCardEntities(checkedEntities, fav);
  }

  Future<int> deleteDuplicates(List<CardEntity> cards, {CardCollection coll}) async {
    if(coll == null){
      return await locator<CardEntityService>().deleteSingleEntities(checkedEntities);
    }else{
      return await locator<CardCollectionService>().deleteCardsFromCollection(checkedEntities, coll);
    }
  }

  createCheckedBoolList(List<CardEntity> cards) {
    checked = List.generate(cards.length,
        (index) => List.filled(cards[index].duplicates.length, false),
        growable: false);
  }

  List<Widget> createDuplicateList(List<CardEntity> cards) {
    List<Widget> listOfCheckboxes = [];
    for (int i = 0; i < cards.length; i++) {
      for (int j = 0; j < cards[i].duplicates.length; j++) {
        listOfCheckboxes.add(
          CheckboxListTile(
            title: Text(
              cards[i].duplicates[j].setCodeInformation.cardInformation.name,
              style: TextStyle(color: ColorPalette.cool_grey[1000]),
            ),
            subtitle: createSubTitle(cards[i].duplicates[j]).isNotEmpty
                ? Text(
                    createSubTitle(cards[i].duplicates[j]),
                    style: TextStyle(color: ColorPalette.cool_grey[400]),
                  )
                : null,
            value: checked[i][j],
            onChanged: (bool value) {
              if(value){
                checkedEntities.add(cards[i].duplicates[j]);
              }else{
                checkedEntities.remove(cards[i].duplicates[j]);
              }
              checked[i][j] = value;
              setState(ViewState.IDLE);
            },
          ),
        );
      }
      listOfCheckboxes.add(Divider(
        color: ColorPalette.cool_grey[1000],
      ));
    }
    return listOfCheckboxes;
  }
}
