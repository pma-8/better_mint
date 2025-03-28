import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_collection_cards.dart';
import 'package:bettermint/business_logic/models/card_collection_cards_dao.dart';
import 'package:bettermint/business_logic/models/card_collection_dao.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/models/card_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_inforamtion_card_entity.dart';
import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:bettermint/business_logic/models/card_information_card_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_information_dao.dart';
import 'package:bettermint/business_logic/models/favorite_view.dart';
import 'package:bettermint/business_logic/models/filter_settings.dart';
import 'package:bettermint/business_logic/models/filter_settings_dao.dart';
import 'package:bettermint/business_logic/models/image_entity.dart';
import 'package:bettermint/business_logic/models/image_entity_dao.dart';
import 'package:bettermint/business_logic/models/set_code.dart';
import 'package:bettermint/business_logic/models/set_code_dao.dart';
import 'package:bettermint/business_logic/models/set_price.dart';
import 'package:bettermint/business_logic/models/set_price_dao.dart';
import 'package:bettermint/business_logic/models/set_price_prices.dart';
import 'package:bettermint/business_logic/models/set_price_prices_dao.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:floor/floor.dart';

// required package imports
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'db.g.dart'; // the generated code will be there

const String databaseFileName = "app_database.db";

@Database(version: 1, entities: [
  CardEntity,
  CardCollection,
  CardCollectionCards,
  CardInformation,
  CardInformationCardEntity,
  FilterSettings,
  SetCode,
  SetPrice,
  SetPricePrices,
  ImageEntity
], views: [
  CardFavoritesView,
  CollectionFavoritesView
])
abstract class DB extends FloorDatabase {
  CardEntityDao get cardEntityDao;
  CardCollectionDao get cardCollectionDao;
  CardCollectionCardsDao get cardCollectionCardsDao;
  CardInformationDao get cardInformationDao;
  CardInformationCardEntityDao get cardInformationCardEntityDao;
  FilterSettingsDao get filterSettingsDao;
  SetCodeDao get setCodeDao;
  SetPriceDao get setPriceDao;
  SetPricePricesDao get setPricePricesDao;
  ImageEntityDao get imageEntityDao;

  Future<void> dropAllTables() async{
        await database.execute('DROP TABLE IF EXISTS $cardEntityTableName');
        await database.execute('DROP TABLE IF EXISTS $cardCollectionTableName');
        await database.execute('DROP TABLE IF EXISTS $cardCollectionCardsTableName');
        await database.execute('DROP TABLE IF EXISTS $cardInformationTableName');
        await database.execute('DROP TABLE IF EXISTS $cardInformationCardEntityTableName');
        await database.execute('DROP TABLE IF EXISTS $filterSettingsTableName');
        await database.execute('DROP TABLE IF EXISTS $setCodeTableName');
        await database.execute('DROP TABLE IF EXISTS $setPriceTableName');
        await database.execute('DROP TABLE IF EXISTS $setPricePricesTableName');
        await database.execute('DROP TABLE IF EXISTS $imageTableName');
  }

  Future<void> refreshDB() async{
    await sqflite.deleteDatabase(databaseFileName);
    unregisterLocator();
    setupLocator();
  }
}