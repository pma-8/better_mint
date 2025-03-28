import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/image_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ImageEntityDao extends BaseEntityDao<ImageEntity>{
  static const String tableName = imageTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<ImageEntity>> findAll();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<ImageEntity> findById(int id);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();

  @Query('DELETE FROM $tableName WHERE id = :id')
  Future<ImageEntity> deleteById(int id);

  @Query('SELECT * FROM $tableName WHERE id IN (:ids)')
  Future<List<ImageEntity>> findByIds(List<int> ids);
}