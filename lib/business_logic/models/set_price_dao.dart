import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/set_price.dart';
import 'package:floor/floor.dart';

@dao
abstract class SetPriceDao extends BaseEntityDao<SetPrice> {
  static const String tableName = setPriceTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<SetPrice>> findAll();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<SetPrice> findById(int id);

  @Query('SELECT * FROM $tableName WHERE id IN (:ids)')
  Future<List<SetPrice>> findByIds(List<int> ids);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();

  @Query('DELETE FROM $tableName WHERE id = :id')
  Future<SetPrice> deleteById(int id);
}
