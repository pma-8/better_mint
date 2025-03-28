import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/db_services/fav_cards_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/business_logic/utils/calculation_service.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends BaseProvider{

  CardCollectionService _cardCollectionService;
  CalculationService _calculationService;
  FavCardsService _favCardsService;
  CardEntityService _cardEntityService = locator<CardEntityService>();

  var totalValue = 0.0;
  var favCards = List<CardEntity>();
  List<CardCollection> mostValuableDecksAndOther = [];
  var mostValuableDecksPercentages = List<double>();
  var decodedFavCardImages = List<Image>();

  List<Color> mostValuableDeckColors = [
  ColorPalette.accent_blue,
  ColorPalette.accent_red.shade900,
  ColorPalette.accent_purple.shade300,
  ColorPalette.cool_grey];

  DashboardProvider(){
    _cardCollectionService = locator<CardCollectionService>();
    _favCardsService = locator<FavCardsService>();
    _calculationService = locator<CalculationService>();
  }

  Future<int> updatePrices() async{
    setState(ViewState.BUSY);
    int res = await _cardEntityService.updatePrices();
    if(res > 0){
      await refresh();
    }
    setState(ViewState.IDLE);
    return res;
  }

  refresh() async {
    setState(ViewState.BUSY);
    await fetchTotalValue();
    await fetchFavCards();
    await fetchMostValuableDecksAndOther();
    await fetchMostValuableDecksPercentages();
    setState(ViewState.IDLE);
  }

  fetchTotalValue() async{
    totalValue = await _calculationService.getTotalPriceOfAllCards();
  }

  Future<List<CardEntity>> fetchFavCards() async{
    favCards = await _favCardsService.getAllFavCards();
    return favCards;
  }

  fetchMostValuableDecksAndOther() async{
    mostValuableDecksAndOther = await _cardCollectionService.getMostValuableDecksAndOther(3);
    return mostValuableDecksAndOther;
  }

  /// used for the progress bar inside the dashboard
  fetchMostValuableDecksPercentages() {
    mostValuableDecksPercentages.clear();
    if(mostValuableDecksAndOther.length == 1){
      return;
    }
    mostValuableDecksAndOther.forEach((element) {
      if(element != null){
        // only valid collections from the database have a total price
          mostValuableDecksPercentages.add(element.totalValue/totalValue);
      }
    });
    return mostValuableDecksPercentages;
  }
}