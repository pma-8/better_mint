import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_collection_cards.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class CardEntityDao extends BaseEntityDao<CardEntity> {
  static const String tableName = cardEntityTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<CardEntity>> findAll();

  @Query('SELECT * FROM $tableName a WHERE a.favorite = 1')
  Future<List<CardEntity>> findAllFavorites();

  @Query('SELECT * FROM $tableName a INNER JOIN $cardCollectionCardsTableName b ON a.id = b.card_entity_id WHERE b.card_collection_id = :collectionId')
  Future<List<CardEntity>> findByCollectionId(int collectionId);

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<CardEntity> findById(int id);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();

  @Query('DELETE FROM $tableName WHERE id = :id')
  Future<CardEntity> deleteById(int id);

  //@Query('SELECT COUNT(*) FROM $tableName')
  //Future<int> getCount();
}
