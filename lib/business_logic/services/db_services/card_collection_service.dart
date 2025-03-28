import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_collection_cards.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/image_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_service.dart';
import 'package:bettermint/business_logic/utils/calculation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'card_entity_service.dart';

class CardCollectionService extends BaseService {
  CalculationService _calculationService = locator<CalculationService>();
  CardEntityService _cardEntityService = locator<CardEntityService>();
  ImageService _imageService = locator<ImageService>();

  List<CardCollection> _collectionCache = List();

  Future<int> getCollectionsCount() async {
    return (await db.cardCollectionDao.findAll()).length;
  }

  _initCollectionCache() async {
    if (_collectionCache.isEmpty) {
      final collections = await db.cardCollectionDao.findAll();
      final cardCollectionCards = await db.cardCollectionCardsDao.findAll();
      final entities =
          await _cardEntityService.loadAllCardEntities(aggregated: false);
      collections.forEach((coll) async {
        List<int> collectionCardsIds = cardCollectionCards
            .where((element) => element.cardCollectionId == coll.id)
            .map((e) => e.cardEntityId)
            .toList();

        double total = 0.0;

        coll.cards = entities.where((card) {
          if (collectionCardsIds.contains(card.id)) {
            total = total + card.setCodeInformation.setPrice.averagePrice;
            return true;
          }
          return false;
        }).toList();

        coll.totalValue = total;

        _collectionCache.add(coll);
      });
    }
  }

  _fillCollectionWithCards(CardCollection coll) async {
    final collectionCardIds =
        (await db.cardCollectionCardsDao.findByCollectionId(coll.id))
            .map((e) => e.cardEntityId);
    final cardEntities =
        await _cardEntityService.loadAllCardEntities(aggregated: false);
    coll.cards = cardEntities
        .where((element) => collectionCardIds.contains(element.id))
        .toList();
  }

  addCardToCollectionCache(CardEntity entity, CardCollection coll) {
    coll.cards.add(entity);
    /*for(CardCollection coll in _collectionCache){
      if(coll.name == collectionName){
        coll.cards.add(entity);
      }
    }*/
  }

  Future<List<CardCollection>> getAllCollections() async {
    await _initCollectionCache();
    return _collectionCache;
  }

  Future<List<int>> getAllCardIdsInCollections() async{
    return (await db.cardCollectionCardsDao.findAll()).map((e) => e.cardEntityId).toList();
  }

  Future<List<CardCollection>> getMostValuableDecksAndOther(int amount) async {
    await _initCollectionCache();
    var totalValue = await _calculationService.getTotalPriceOfAllCards();
    _collectionCache.sort((a, b) => b.totalValue.compareTo(a.totalValue));

    List<CardCollection> mostValuable = [];
    if (_collectionCache.length >= amount) {
      mostValuable.addAll(_collectionCache.getRange(0, amount));
    } else {
      mostValuable.addAll(_collectionCache);
    }

    double mostValuableDecksTotal = 0.0;
    mostValuable.forEach((element) {
      mostValuableDecksTotal = mostValuableDecksTotal + element.totalValue;
    });

    CardCollection coll = CardCollection(name: "Other");
    coll.totalValue = totalValue - mostValuableDecksTotal;
    mostValuable.add(coll);

    return mostValuable;
  }

  Future<Map<int, List<Image>>> getCollectionPreviewImages(
      List<CardCollection> collections, int amountOfPreviewImages) async {
    Map<int, List<Image>> previewImages = Map();
    for (var element in collections) {
      print("collection " + element.toString());
      List<CardEntity> collPrevEntities = List();
      if(element.cards != null){
        int entLength = element.cards.length;
        if (entLength < amountOfPreviewImages) {
          collPrevEntities.addAll(element.cards.getRange(0, entLength));
        } else {
          collPrevEntities
              .addAll(element.cards.getRange(0, amountOfPreviewImages));
        }
        previewImages[element.id] =
            (await _imageService.getImagesFromEntities(collPrevEntities))
                .map((e) => e.image)
                .toList();
      }
      }
    return previewImages;
  }

  double getPriceOfCollection(int collectionId) {
    return _collectionCache
        .firstWhere((element) => element.id == collectionId)
        .totalValue;
  }

  changeFavState(int collectionId) async {
    await db.cardCollectionDao.flipFavoriteStatus(collectionId);
  }

  Future<CardCollection> addNewCollection(String collectionName) async {
    int collId = await db.cardCollectionDao
        .insertEntity(CardCollection(name: collectionName, favorite: false));

    final coll = (await db.cardCollectionDao.findById(collId));
    coll.cards = [];
    _collectionCache.add(coll);
    return coll;
  }

  Future<List<int>> addNewCollectionWithCards(
      String collectionName, List<CardEntity> cards) async {
    final coll = await addNewCollection(collectionName);
    List<CardCollectionCards> cardsToCollection = List();

    for (int id in cards.map((e) => e.id)) {
      cardsToCollection.add(
          CardCollectionCards(cardEntityId: id, cardCollectionId: coll.id));
    }

    final cardCollectionCardsIds =
        await db.cardCollectionCardsDao.insertEntities(cardsToCollection);
    await _fillCollectionWithCards(coll);

    coll.cards = cards;
    coll.totalValue =
        _calculationService.calculateTotalPriceOfCards(coll.cards);
    return cardCollectionCardsIds;
  }

  deleteCollection(CardCollection coll) async {
    await db.cardCollectionDao.deleteById(coll.id);
    List<CardCollectionCards> cardCollCards = await db.cardCollectionCardsDao.findByCollectionId(coll.id);
    await db.cardCollectionCardsDao.deleteEntities(cardCollCards);
    _collectionCache.removeWhere((element) => element.id == coll.id);
  }

  Future<List<int>> addCardsToCollection(List<CardEntity> cards, CardCollection coll)async{
    List<CardCollectionCards> cardCollCards = [];
    for(CardEntity card in cards){
      cardCollCards.add(CardCollectionCards(cardCollectionId: coll.id, cardEntityId: card.id));
    }

    List<int> result = await db.cardCollectionCardsDao.insertEntities(cardCollCards);
    coll.cards.addAll(cards);
    coll.totalValue = 0;

    coll.cards.forEach((element) {
      coll.totalValue = coll.totalValue + element.setCodeInformation.setPrice.averagePrice;
    });

    return result;
  }

  Future<int> deleteCardsFromCollection(List<CardEntity> todelete, CardCollection coll) async{
    List<CardCollectionCards> cardCollCards = await db.cardCollectionCardsDao.findByCollectionId(coll.id);
    List<int> toDeleteIds = todelete.map((e) => e.id).toList();
    cardCollCards.retainWhere((element) => toDeleteIds.contains(element.cardEntityId));
    int res = await db.cardCollectionCardsDao.deleteEntities(cardCollCards);
    coll.cards.removeWhere((element) => todelete.contains(element));
    todelete.forEach((element) {
      coll.totalValue = coll.totalValue - element.setCodeInformation.setPrice.averagePrice;
    });
    return res;
  }

  deleteCardsFromCollectionCache(List<CardEntity> entities){
    entities.forEach((card) {
      _collectionCache.forEach((coll) {
        coll.cards.remove(card);
      });
    });
  }
}
