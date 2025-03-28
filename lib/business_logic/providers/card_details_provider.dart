import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/ui/utils/BoolConverter.dart';

import 'add_card_provider.dart';

class CardDetailsProvider extends BaseProvider {
  List<List<String>> createInfoList(CardEntity pCardEntity) {
    List<String> cardAttributes = [];
    List<String> titles = [];
    var cardInfo = pCardEntity.setCodeInformation.cardInformation;


    if (cardInfo.name.isNotEmpty) {
      cardAttributes.add(cardInfo.name);
      titles.add("Name");
    }

    if (pCardEntity.setCode.isNotEmpty) {
      cardAttributes.add(pCardEntity.setCode);
      titles.add("Set-Code");
    }

    if (pCardEntity.setCode != null &&
        pCardEntity.setCodeInformation.rarity.isNotEmpty) {
      cardAttributes.add(pCardEntity.setCodeInformation.rarity);
      titles.add("Rarity");
    }

    if (cardInfo.attribute != null &&
        cardInfo.race.isNotEmpty) {
      cardAttributes.add(cardInfo.race);
      titles.add("Race");
    }

    if (cardInfo.level != null) {
      cardAttributes
          .add(cardInfo.level.toString());
      titles.add("Stars(Level)");
    }

    if (cardInfo.cardType.isNotEmpty) {
      cardAttributes
          .add(cardInfo.cardType);
      titles.add("Card Type");
    }

    if (cardInfo.attribute != null &&
        cardInfo.attribute.isNotEmpty) {
      cardAttributes
          .add(cardInfo.attribute);
      titles.add("Attribute");
    }

    if (cardInfo.banned != null) {
      cardAttributes.add(BoolConverter.boolToWord(
          cardInfo.banned));
      titles.add("Banned");
    }

    if (cardInfo.staple != null) {
      cardAttributes.add(BoolConverter.boolToWord(
          cardInfo.staple));
      titles.add("Staple");
    }

    if (cardInfo.atkPoints != null) {
      cardAttributes.add(
          cardInfo.atkPoints.toString());
      titles.add("ATK Points");
    }

    if (cardInfo.defPoints != null) {
      cardAttributes.add(
          cardInfo.defPoints.toString());
      titles.add("DEF Points");
    }




    return [cardAttributes, titles];
  }

  Map<String, double> createMarketList(CardEntity pCardEntity) {
    Map<String, double> cardAttributesAndPrices = Map();
    var priceInfo = pCardEntity.setCodeInformation.setPrice;

    if (priceInfo.averagePrice != null) {
      cardAttributesAndPrices["Average Price"] = priceInfo.averagePrice;
    }

    if (priceInfo.highestPrice != null) {
      cardAttributesAndPrices["Highest Price"] = priceInfo.highestPrice;
    }

    if (priceInfo.lowestPrice != null) {
      cardAttributesAndPrices["Lowest Price"] = priceInfo.lowestPrice;
    }

    if (priceInfo.shift != null) {
      cardAttributesAndPrices["Price Shift"] = priceInfo.shift;
    }

    if (priceInfo.shift3 != null) {
      cardAttributesAndPrices["Price Shift 3 Days"] = priceInfo.shift3;
    }

    if (priceInfo.shift7 != null) {
      cardAttributesAndPrices["Price Shift 7 Days"] = priceInfo.shift7;
    }

    if (priceInfo.shift30 != null) {
      cardAttributesAndPrices["Price Shift 30 Days"] = priceInfo.shift30;
    }

    if (priceInfo.shift90 != null) {
      cardAttributesAndPrices["Price Shift 90 Days"] = priceInfo.shift90;
    }

    if (priceInfo.shift180 != null) {
      cardAttributesAndPrices["Price Shift 180 Days"] = priceInfo.shift180;
    }

    if (priceInfo.shift365 != null) {
      cardAttributesAndPrices["Price Shift 365 Days"] = priceInfo.shift365;
    }

    return cardAttributesAndPrices;
  }

  Map<String, int> createOwnedCardsList(CardEntity pCardEntity){
    Map<String, int> ownedCards = Map();

    bool duplicatesExits = pCardEntity.duplicates != null && pCardEntity.duplicates.isNotEmpty;

    if (duplicatesExits) {
      int firstEditionCount = 0;

      Map<String,int> conditionMap = new Map<String,int>();

      for(int i = 0; i < AddCardProvider.conditions.length; i++) {
        conditionMap[AddCardProvider.conditions[i]] = 0;
      }

      for(CardEntity cardEntity in pCardEntity.duplicates)
      {
        firstEditionCount = cardEntity.firstEdition != null && cardEntity.firstEdition ? firstEditionCount + 1 : firstEditionCount;
        conditionMap[cardEntity.condition]++;
      }

      ownedCards["First Editions"] = firstEditionCount;

      // iterate backwards so
      for(int i = AddCardProvider.conditions.length - 1; i >= 0 ; i--) {
        String conditionTitle = AddCardProvider.conditions[i];
        int conditionCount = conditionMap[conditionTitle];
        conditionTitle = conditionTitle == "" ? "Unknown" : conditionTitle;

        ownedCards[conditionTitle] = conditionCount;
      }
    }

    return ownedCards;
  }
}
