import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:bettermint/business_logic/services/db_services/image_service.dart';
import 'package:bettermint/business_logic/utils/base_service.dart';

import '../service_locator.dart';
import 'card_entity_service.dart';

class FavCardsService extends BaseService{

  CardEntityService _ces = locator<CardEntityService>();
  ImageService _imageService = locator<ImageService>();

  Future<List<CardEntity>> getAllFavCards({List<CardEntity> cards}) async{
    var allCards = await _ces.loadAllCardEntities(aggregated: true);
    var favCards = allCards.where((element) => element.duplicatesFav).toList();
    favCards = await _imageService.getImagesFromEntities(favCards);
    return favCards;
  }

  Future<List<CardInformation>> getAllCardsCardInformation() async{
    var favCards = await getAllFavCards();
    return favCards.map((e) => e.setCodeInformation.cardInformation).toList();
  }
}