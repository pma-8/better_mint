import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_collection_cards.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/models/card_inforamtion_card_entity.dart';
import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:bettermint/business_logic/models/set_code.dart';
import 'package:bettermint/business_logic/models/set_price.dart';
import 'package:bettermint/business_logic/services/api_services/prodeck_api_service.dart';
import 'package:bettermint/business_logic/services/api_services/yugioh_prices_api_serice.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/image_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_service.dart';

class CardEntityService extends BaseService {
  YugiohPricesAPIService _pricesApi = locator<YugiohPricesAPIService>();
  ProdeckAPIService _prodeckApi = locator<ProdeckAPIService>();
  ImageService _imageService = locator<ImageService>();

  List<CardEntity> _cardEntityCache = List();
  List<CardEntity> _aggregatedCardEntityCache = List();

  Future<List<CardEntity>> loadAllCardEntities({bool aggregated = true}) async {
    if (_cardEntityCache.isEmpty) {
      await _initCardEntityCache();
      await _imageService.getImagesFromEntities(_cardEntityCache);
    }
    return aggregated ? _aggregatedCardEntityCache : _cardEntityCache;
  }

  List<CardEntity> aggregateDuplicates(List<CardEntity> toAggregate) {
    List<CardEntity> aggregated = List();
    if(toAggregate == null){
      return aggregated;
    }

    for (CardEntity cardEntity in toAggregate) {
      int distinctIndex = aggregated
          .indexWhere((element) => element.setCode == cardEntity.setCode);

      if (distinctIndex == -1) {
        cardEntity.latestCreateTime = cardEntity.createTime;
        final topLevelEntity = _createTopLevelEntity(cardEntity);
        aggregated.add(topLevelEntity);
        continue;
      }
      CardEntity distinctEntity = aggregated[distinctIndex];
      distinctEntity.duplicates.add(cardEntity);

      distinctEntity.duplicatesFav = distinctEntity.duplicatesFav
          ? distinctEntity.duplicatesFav
          : cardEntity.favorite;

      var distinctEntityTime = distinctEntity.latestCreateTime;
      var cardEntityTime = cardEntity.createTime;
      var distinctTimeBeforeEntityTime = (DateTime.parse(distinctEntityTime)
              .compareTo(DateTime.parse(cardEntityTime)) <
          0);
      distinctEntity.latestCreateTime =
          distinctTimeBeforeEntityTime ? cardEntityTime : distinctEntityTime;
    }
    return aggregated;
  }

  CardEntity _createTopLevelEntity(CardEntity cardEntity) {
    final topLevelEntity = CardEntity(id: cardEntity.id);
    topLevelEntity.setCode = cardEntity.setCode;
    topLevelEntity.setCodeInformation = cardEntity.setCodeInformation;
    topLevelEntity.latestCreateTime = cardEntity.createTime;
    topLevelEntity.duplicates.add(cardEntity);
    topLevelEntity.duplicatesFav = cardEntity.favorite;
    topLevelEntity.favorite = cardEntity.favorite;
    return topLevelEntity;
  }

  _initCardEntityCache() async {
    List<CardEntity> allEntities = await db.cardEntityDao.findAll();
    _cardEntityCache = await _fillCardEntities(allEntities);
    _aggregatedCardEntityCache = aggregateDuplicates(_cardEntityCache);
  }

  Future<List<CardEntity>> _fillCardEntities(List<CardEntity> entities) async {
    //map all card entities to their setCode to reduce runtime
    //when setting the actual setCode objects
    Map<String, List<CardEntity>> entityToSetCodeMap = new Map();

    List<String> setCodeIds = [];

    for (CardEntity entity in entities) {
      if (entityToSetCodeMap[entity.setCode] == null) {
        List<CardEntity> entitiesPerSetCode = [];
        entitiesPerSetCode.add(entity);
        entityToSetCodeMap[entity.setCode] = entitiesPerSetCode;
        setCodeIds.add(entity.setCode);
      } else {
        entityToSetCodeMap[entity.setCode].add(entity);
      }
    }

    List<SetCode> setCodes = await db.setCodeDao.findBySetCodes(setCodeIds);
    Map<int, List<SetCode>> setCodeToCardInfoMap = new Map();
    List<int> cardInfoIds = [];

    for (SetCode setCode in setCodes) {
      setCode.setPrice = await db.setPriceDao.findById(setCode.setPriceId);

      //set Setcode objects to card entities
      for (CardEntity entity in entityToSetCodeMap[setCode.setCode]) {
        entity.setCodeInformation = setCode;
      }

      if (setCodeToCardInfoMap[setCode.cardInformationId] == null) {
        List<SetCode> setCodesPerCardInfo = [];
        setCodesPerCardInfo.add(setCode);
        setCodeToCardInfoMap[setCode.cardInformationId] = setCodesPerCardInfo;
        cardInfoIds.add(setCode.cardInformationId);
      } else {
        setCodeToCardInfoMap[setCode.cardInformationId].add(setCode);
      }
    }

    List<CardInformation> cardInfos =
        await db.cardInformationDao.findByIds(cardInfoIds);

    for (CardInformation cardInfo in cardInfos) {
      for (SetCode setCode in setCodeToCardInfoMap[cardInfo.id]) {
        setCode.cardInformation = cardInfo;
      }
    }

    return entities;
  }

  Future<void> addCard(String setCode, CardCollection collection, bool fav,
      String condition, bool firstEdition) async  {
    bool setCodeAlreadyExists = true;
    SetCode newSetCode = await db.setCodeDao.findBySetCode(setCode);

    if (newSetCode == null) {
      setCodeAlreadyExists = false;
      newSetCode = await _pricesApi.fetchSetCode(setCode);
    }

    int cardInformationId = newSetCode.cardInformationId;
    // can only be null if setcode is new(not already exists)
    if (cardInformationId == null) {
      String cardName = newSetCode.cardInformation.name;
      cardName = cardName.replaceAll(' (original)', '');

      // check if a cardinformation with this name is already inside the database
      List<CardInformation> cardInfos =
          await db.cardInformationDao.findByName(cardName);

      // if no cardinformation was found in the database fetch the cardinfo from prodeck
      if (cardInfos.length == 0) {
        cardInfos = await _prodeckApi.fetchCardInfosByName([cardName]);
        cardInformationId =
            await db.cardInformationDao.insertEntity(cardInfos[0]);
      } else {
        cardInformationId = cardInfos[0].id;
      }

      newSetCode.cardInformationId = cardInformationId;
    }

    int setPriceId = newSetCode.setPriceId;
    if (setPriceId == null) {
      setPriceId = await db.setPriceDao.insertEntity(newSetCode.setPrice);
    }

    if (!setCodeAlreadyExists) {
      newSetCode.cardInformationId = cardInformationId;
      newSetCode.setPriceId = setPriceId;
      int imageId = await db.imageEntityDao.insertEntity(newSetCode.image);
      newSetCode.imageId = imageId;
      await db.setCodeDao.insertEntity(newSetCode);
    }

    CardEntity newEntity = CardEntity(
        favorite: fav,
        setCode: newSetCode.setCode,
        firstEdition: firstEdition,
        condition: condition);
    int cardEntityId = await db.cardEntityDao.insertEntity(newEntity);

    // TODO: is this call still necessary? Check if this class/call is deprecated
    CardInformationCardEntity cardInformationCardEntity =
        CardInformationCardEntity(
            cardInformationId: cardInformationId, cardEntityId: cardEntityId);
    await db.cardInformationCardEntityDao
        .insertEntity(cardInformationCardEntity);

    CardEntity toCache = await _fillCardEntity(cardEntityId);
    _cardEntityCache.add(toCache);
    _addCardToAggregatedCache(toCache);

    await _imageService.getImagesFromEntities([toCache]);

    if (collection == null) {
      return toCache;
    }

    CardCollectionCards newCardToCollection = CardCollectionCards(
        cardEntityId: cardEntityId, cardCollectionId: collection.id);
    await db.cardCollectionCardsDao.insertEntity(newCardToCollection);
    collection.cards.add(toCache);
    collection.totalValue += toCache.setCodeInformation.setPrice.averagePrice;

    return toCache;
  }

  Future<CardEntity> _fillCardEntity(int id) async {
    CardEntity card = await db.cardEntityDao.findById(id);
    return (await _fillCardEntities([card])).first;
  }

  Future<int> deleteSingleEntities(List<CardEntity> singleEntities) async{
    if(singleEntities.isEmpty){
      return 1;
    }
    singleEntities.forEach((element) {
      _deleteSingleEntityFromCache(element);
    });

    //List<CardCollectionCards> cardCollCards = await db.cardCollectionCardsDao.findAll();
    //List<int> idsToDelete = singleEntities.map((e) => e.id);
    //cardCollCards.retainWhere((element) => idsToDelete.contains(element.cardEntityId));
    //await db.cardCollectionCardsDao.deleteEntities(cardCollCards);
    CardCollectionService css = locator<CardCollectionService>();
    css.deleteCardsFromCollectionCache(singleEntities);
    int res = await db.cardEntityDao.deleteEntities(singleEntities);
    print("deleted res "+res.toString());
    return res;
  }

  _deleteSingleEntityFromCache(CardEntity singleEntity){
    _cardEntityCache.remove(singleEntity);
    var topLvl = _aggregatedCardEntityCache
        .firstWhere((aggr) => aggr.setCode == singleEntity.setCode);
    topLvl.duplicates.remove(singleEntity);
    if(topLvl.duplicates.isEmpty){
      _aggregatedCardEntityCache.remove(topLvl);
    }
  }

  Future<int> favCardEntities(
      List<CardEntity> singleEntities, bool pFav) async {
    if(singleEntities.isNotEmpty) {
      List<CardEntity> toFav = [];
      singleEntities.forEach(
            (card) {
          toFav.add(card);
          card.favorite = pFav;
          _aggregatedCardEntityCache.forEach(
                (topEntity) {
              if (topEntity.duplicates.contains(card)) {
                if (topEntity.duplicates.length == 1) {
                  topEntity.duplicatesFav = pFav;
                } else if (topEntity.duplicates.length > 1) {
                  topEntity.duplicatesFav = topEntity.duplicates
                      .where((element) => element.favorite)
                      .length >
                      0
                      ? true
                      : false;
                }
              }
            },
          );
        },
      );
      return await db.cardEntityDao.updateEntities(toFav);
    }
    return 1;
  }

  _addCardToAggregatedCache(CardEntity card) {
    for (var element in _aggregatedCardEntityCache) {
      if (element.setCode == card.setCode) {
        element.duplicates.add(card);
        element.latestCreateTime = card.createTime;
        element.duplicatesFav =
            element.duplicatesFav ? element.duplicatesFav : card.favorite;
        return;
      }
    }
    _aggregatedCardEntityCache.add(_createTopLevelEntity(card));
  }

  Future<int> updatePrices() async {
    var now = DateTime.now().toString();
    List<String> setCodeStrings = List();
    List<CardEntity> toUpdate = _cardEntityCache.where((element) {
      var setPrice = element.setCodeInformation.setPrice;
      var setCode = element.setCodeInformation.setCode;
      if (setPrice.updatedAt == null ||
          calcDateDiff(DateTime.parse(setPrice.updatedAt)) < -12) {
        setCodeStrings.add(setCode);
        return true;
      }
      return false;
    }).toList();

    if (toUpdate.isEmpty) {
      return 0;
    }
    List<SetCode> updatedSetCodes = [];
    try {
      updatedSetCodes =
          await _pricesApi.fetchSetCodes(setCodeStrings, withImage: false);
    } catch (e) {
      return -1;
    }

    List<SetPrice> updatedSetPrices = List();

    for (CardEntity card in toUpdate) {
      var updatedSetPrice = updatedSetCodes
          .firstWhere((code) => card.setCode == code.setCode)
          .setPrice;
      var cardSetPrice = card.setCodeInformation.setPrice;
      updatedSetPrice.updatedAt = now;
      print(updatedSetPrice.shift3);
      cardSetPrice.averagePrice = updatedSetPrice.averagePrice;
      cardSetPrice.lowestPrice = updatedSetPrice.lowestPrice;
      cardSetPrice.highestPrice = updatedSetPrice.highestPrice;
      cardSetPrice.shift3 = updatedSetPrice.shift3;
      cardSetPrice.shift7 = updatedSetPrice.shift7;
      cardSetPrice.shift30 = updatedSetPrice.shift30;
      cardSetPrice.shift90 = updatedSetPrice.shift90;
      cardSetPrice.shift180 = updatedSetPrice.shift180;
      cardSetPrice.shift365 = updatedSetPrice.shift365;
      cardSetPrice.updatedAt = now;
      updatedSetPrices.add(updatedSetPrice);
    }

    print("successfully updated prices");
    await db.setPriceDao.updateEntities(updatedSetPrices);
    return 1;
  }

  ///Yesterday : calculateDifference(date) == -1.
  ///Today : calculateDifference(date) == 0.
  ///Tomorrow : calculateDifference(date) == 1.
  int calcDateDiff(DateTime date) {
    DateTime now = DateTime.now();
    return date.difference(now).inHours;
  }
}
