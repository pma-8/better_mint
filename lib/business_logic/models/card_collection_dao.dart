import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:floor/floor.dart';

@dao
abstract class CardCollectionDao extends BaseEntityDao<CardCollection> {
  static const String tableName = cardCollectionTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<CardCollection>> findAll();

  @Query('SELECT * FROM $tableName a WHERE a.favorite = 1')
  Future<List<CardCollection>> findAllFavorites();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<CardCollection> findById(int id);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();

  @Query('DELETE FROM $tableName WHERE id = :id')
  Future<CardCollection> deleteById(int id);

  @Query(
      'UPDATE $tableName SET favorite = ((favorite | 1) - (favorite & 1)) WHERE id = :id')
  Future<void> flipFavoriteStatus(int id);
}
