import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_collection_cards.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:bettermint/business_logic/models/set_code.dart';
import 'package:bettermint/business_logic/models/set_price.dart';
import 'package:bettermint/business_logic/services/api_services/prodeck_api_service.dart';
import 'package:bettermint/business_logic/services/api_services/yugioh_prices_api_serice.dart';
import 'package:bettermint/business_logic/services/db_services/db.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';

class DummyDataService {
  YugiohPricesAPIService pricesService;
  ProdeckAPIService proDeckApiService;
  DB dbService;

  List<String> setCodes = [
    //"PSV-000", // Jinzo
    "YAP1-EN007",
    "PGLD-EN030", //Obelisk the Tormentor
    "YGLD-ENG01", // slifer the sky dragon
    "BLHR-EN023", // "T.G. Gear Zombie",
    "LOB-EN053", // Raigeki
    "PEVO-EN001", // "Astrograph Sorcerer",
    "LVAL-EN011", // "Gorgonic Golem",
    "BLLR-EN056", // "Elemental HERO Nova Master",
    "WIRA-EN015", // Raidraptor - Last Strix",
    "LED7-EN052", // A Wild Monster Appears!
    "SR08-EN009", // Mythical Beast Medusa
    "ORCS-EN024", // Wind-Up Honeybee
    "SDPL-EN008", // Segmental Dragon
    "PRIO-EN007", // Blizzard Thunderbird
    "DB2-EN170", // Gradius' Option
    "EXVC-EN029", // Shien's Advisor
    "LDS1-EN006", // Malefic Red-Eyes Black Dragon
    "MDP2-EN011", // Kaiser Dragon
    "LED3-EN006", // Blue Eyes White Dragon
    "YSKR-EN001",
    "MVP1-ENGV4",
    "YAP1-EN001",
    "MAGO-EN001"
  ];

  Future<void> startDatabase() async {
    //await (await locator.getAsync<DB>()).refreshDB();
    dbService = await locator.getAsync<DB>();
  }

  /// inserts all dummy cards and favorizes the last 5 of them. Adds two card
  /// collections with 5 cards and favorizes one of them
  /// at the moment without set prices
  Future<void> createInitialData() async {
    /// Make sure to always init data into clean db
    await (await locator.getAsync<DB>()).refreshDB();

    pricesService = locator<YugiohPricesAPIService>();
    proDeckApiService = locator<ProdeckAPIService>();

    dbService = await locator.getAsync<DB>();

    Map<String, List<SetCode>> cardNameToSetCodes = new Map();
    List<CardEntity> cardEntities = [];
    List<String> cardNames = [];
    var setCodeObjects = await pricesService.fetchSetCodes(setCodes);

    for (int i = 0; i < setCodes.length; i++) {
      // favorize the last 5 cards
      bool favorite = (i > setCodes.length - 6) ? true : false;
      var cardEntity = CardEntity(setCode: setCodes[i], favorite: favorite, condition: "Mint", firstEdition: true);
      cardEntities.add(cardEntity);
      String cardName = setCodeObjects[i].cardInformation.name;
      //Special (original) suffix edge case
      cardName = cardName.replaceAll(' (original)', '');
      if (cardNameToSetCodes[cardName] == null) {
        List<SetCode> setCodesOfName = [];
        setCodesOfName.add(setCodeObjects[i]);
        cardNameToSetCodes[cardName] = setCodesOfName;

        cardNames.add(cardName);
      } else {
        cardNameToSetCodes[cardName].add(setCodeObjects[i]);
      }
    }

    ///insert example card infos
    var cardInfos = await proDeckApiService.fetchCardInfosByName(cardNames);
    if (cardInfos.length == 0) {
      print("cardinfos empty");
      return;
    }
    var entityIds =
        await dbService.cardInformationDao.insertEntities(cardInfos);

    for (int i = 0; i < entityIds.length; i++) {
      CardInformation cardInformation = cardInfos[i];
      List<SetCode> setCodesOfName = cardNameToSetCodes[cardInformation.name];
      for (SetCode setCode in setCodesOfName) {
        setCode.cardInformationId = entityIds[i];
      }
    }

    List<SetPrice> setPrices = List();
    for (SetCode setCode in setCodeObjects) {
      if (setCode.setPrice != null) {
        setPrices.add(setCode.setPrice);
      }
    }

    var setPriceIds = await dbService.setPriceDao.insertEntities(setPrices);

    int i = 0;
    setCodeObjects.forEach((element) {
      if(element.setPrice != null){
        element.setPriceId = setPriceIds.elementAt(i);
        i++;
      }
    });

    for(SetCode sc in setCodeObjects){
      var imageId = await dbService.imageEntityDao.insertEntity(sc.image);
      sc.imageId = imageId;
    }

    await dbService.setCodeDao.insertEntities(setCodeObjects);
    await dbService.cardEntityDao.insertEntities(cardEntities);

    CardCollection collectionOne =
        CardCollection(name: "Good Ones", favorite: true);
    CardCollection collectionTwo =
        CardCollection(name: "Bad Ones", favorite: false);

    //insert 2 collections
    var collIdOne =
        await dbService.cardCollectionDao.insertEntity(collectionOne);
    var collIdTwo =
        await dbService.cardCollectionDao.insertEntity(collectionTwo);

    //fill the first collection with 5 cards
    List<CardCollectionCards> cccs = List<CardCollectionCards>();
    for (var i = 0; i < 5; i++) {
      cccs.add(CardCollectionCards(
          cardCollectionId: collIdOne, cardEntityId: entityIds[i]));
    }
    await dbService.cardCollectionCardsDao.insertEntities(cccs);

    //fill the second collection with 5 cards
    cccs.clear();
    for (var i = 5; i < 10; i++) {
      cccs.add(CardCollectionCards(
          cardCollectionId: collIdTwo, cardEntityId: entityIds[i]));
    }
    await dbService.cardCollectionCardsDao.insertEntities(cccs);
  }
}
