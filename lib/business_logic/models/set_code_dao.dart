import 'package:bettermint/business_logic/models/set_code.dart';
import 'package:floor/floor.dart';

@dao
abstract class SetCodeDao {
  static const String tableName = setCodeTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<SetCode>> findAll();

  @Query('SELECT * FROM $tableName WHERE set_code = :setCode')
  Future<SetCode> findBySetCode(String setCode);

  @Query('SELECT * FROM $tableName WHERE set_code IN (:setCodes)')
  Future<List<SetCode>> findBySetCodes(List<String> setCodes);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();

  @Query('DELETE FROM $tableName WHERE set_code = :setCode')
  Future<SetCode> deleteBySetCode(String setCode);

  @insert
  Future<int> insertEntity(SetCode entity);

  @insert
  Future<List<int>> insertEntities(List<SetCode> entities);

  @update
  Future<int> updateEntity(SetCode entity);

  @update
  Future<int> updateEntities(List<SetCode> entities);

  @delete
  Future<int> deleteEntity(SetCode entity);

  @delete
  Future<int> deleteEntities(List<SetCode> entities);
}
