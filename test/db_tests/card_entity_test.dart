import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/models/card_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_information_dao.dart';
import 'package:bettermint/business_logic/services/db_services/db.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('database card entity dao tests', () {
    DB database;
    CardEntityDao cardEntityDao;
    CardInformationDao cardInformationDao;

    setUp(() async {
      database = await $FloorDB.inMemoryDatabaseBuilder().build();
      cardEntityDao = database.cardEntityDao;
      cardInformationDao = database.cardInformationDao;
    });

    tearDown(() async {
      await database.close();
    });

    ///SELECTS

    test('find all cards', () async {
      final card = CardEntity();
      final cardtwo = CardEntity();
      await cardEntityDao.insertEntity(card);
      await cardEntityDao.insertEntity(cardtwo);
      final actual = await cardEntityDao.findAll();
      expect(actual.length, equals(2));
    });

    test('find card by id', () async {
      final card = CardEntity();
      final cardid = await cardEntityDao.insertEntity(card);
      final actual = await cardEntityDao.findById(cardid);
      expect(actual.id, equals(cardid));
    });

    ///UPDATES

    test('update card', () async {
      final card = CardEntity(favorite: false);
      final cardid = await cardEntityDao.insertEntity(card);
      CardEntity dbCard = await cardEntityDao.findById(cardid);

      dbCard.favorite = true;
      await cardEntityDao.updateEntity(dbCard);
      dbCard = await cardEntityDao.findById(cardid);

      expect(dbCard.favorite, equals(true));
    });

    test('update cards', () async {
      final firstCard = CardEntity(favorite: false);
      final secondCard = CardEntity(favorite: false);
      List<CardEntity> cards = [firstCard, secondCard];
      await cardEntityDao.insertEntities(cards);

      cards = await cardEntityDao.findAll();
      cards.forEach((element) {element.favorite = true;});
      await cardEntityDao.updateEntities(cards);

      cards = await cardEntityDao.findAll();
      bool fav = false;
      cards.forEach((element) { fav = element.favorite;});

      expect(fav, equals(true));
    });

    ///DELETES

    test('delete card', () async {
      final firstCard = CardEntity(favorite: false);
      final secondCard = CardEntity(favorite: false);
      final id = await cardEntityDao.insertEntity(firstCard);
      await cardEntityDao.insertEntity(secondCard);

      final allCards = await cardEntityDao.findAll();
      await cardEntityDao.deleteEntity(await cardEntityDao.findById(id));
      final notAllCards = await cardEntityDao.findAll();

      expect(notAllCards.length, lessThan(allCards.length));
    });

    test('delete cards', () async {
      final firstCard = CardEntity(favorite: false);
      final secondCard = CardEntity(favorite: false);
      List<CardEntity> cards = [firstCard, secondCard];
      await cardEntityDao.insertEntities(cards);

      final allCards = await cardEntityDao.findAll();
      await cardEntityDao.deleteEntities(allCards);
      final notAllCards = await cardEntityDao.findAll();

      expect(notAllCards.length, equals(0));
    });

    test('delete card by id', () async {
      final firstCard = CardEntity(favorite: false);
      final secondCard = CardEntity(favorite: false);
      final id = await cardEntityDao.insertEntity(firstCard);
      await cardEntityDao.insertEntity(secondCard);

      final allCards = await cardEntityDao.findAll();
      await cardEntityDao.deleteById(id);
      final notAllCards = await cardEntityDao.findAll();

      expect(notAllCards.length, lessThan(allCards.length));
    });

    ///FOREIGN KEY
/*
    test('test cardinformation foreign Key', () async {
      final cardInfo = CardInformation(
        atkPoints: 100,
        attribute: "attribute",
        banned: true,
        cardPrice: 23,
        cardType: "type",
        defPoints: 100,
        level: 1,
        name: "name",
        description: "desc",
        staple: false,
        race: "r"
      );
      final cardInfoId = await cardInformationDao.insertEntity(cardInfo);
      final dbCardInfo = await cardInformationDao.findById(cardInfoId);

      final card = CardEntity(cardInformationId: dbCardInfo.id, favorite: true);
      final cardid = await cardEntityDao.insertEntity(card);
      final dbCard = await cardEntityDao.findById(cardid);

      final fetchedCardInfo =
          await cardInformationDao.findById(dbCard.cardInformationId);

      bool same = (dbCardInfo.staple == fetchedCardInfo.staple &&
          dbCardInfo.banned == fetchedCardInfo.banned &&
          dbCardInfo.cardPrice == fetchedCardInfo.cardPrice &&
          dbCardInfo.attribute == fetchedCardInfo.attribute &&
          dbCardInfo.cardType == fetchedCardInfo.cardType &&
          dbCardInfo.defPoints == fetchedCardInfo.defPoints &&
          dbCardInfo.level == fetchedCardInfo.level &&
          dbCardInfo.name == fetchedCardInfo.name &&
          dbCardInfo.description == fetchedCardInfo.description &&
          dbCardInfo.race == fetchedCardInfo.race &&
          dbCardInfo.atkPoints == fetchedCardInfo.atkPoints &&
          dbCardInfo.defPoints == fetchedCardInfo.defPoints);
      expect(same, equals(true));
    }

    ); */
  }
  );
}