import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_collection_cards.dart';
import 'package:floor/floor.dart';

@dao
abstract class CardCollectionCardsDao
    extends BaseEntityDao<CardCollectionCards> {
  static const String tableName = cardCollectionCardsTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<CardCollectionCards>> findAll();

  @Query('SELECT * FROM $tableName WHERE card_collection_id = :id')
  Future<List<CardCollectionCards>> findByCollectionId(int id);

  @Query('DELETE FROM $tableName WHERE card_collection_id = :id')
  Future<CardCollectionCards> deleteByCollectionId(int id);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();
}
