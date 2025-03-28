import 'dart:async';

import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_service.dart';

class CalculationService extends BaseService{

  double calculateTotalPriceOfCards(List<CardEntity> cards) {
    double total = 0.0;
    cards.forEach((card) { total = total + card.setCodeInformation.setPrice.averagePrice;});
    return total;
  }

  Future<double> getTotalPriceOfAllCards() async {
    var allCards = await locator<CardEntityService>().loadAllCardEntities(aggregated: false);
    return calculateTotalPriceOfCards(allCards);
  }

}