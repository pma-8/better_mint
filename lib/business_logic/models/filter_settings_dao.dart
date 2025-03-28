import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/filter_settings.dart';
import 'package:floor/floor.dart';

@dao
abstract class FilterSettingsDao extends BaseEntityDao<FilterSettings> {
  static const String tableName = filterSettingsTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<FilterSettings>> findAll();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<FilterSettings> findById(int id);

  @Query('SELECT * FROM $tableName WHERE page_index = :pageIndex')
  Future<FilterSettings> findByPageIndex(int pageIndex);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();

  @Query('DELETE FROM $tableName WHERE id = :id')
  Future<FilterSettings> deleteById(int id);

  @Query('UPDATE $tableName SET sort_by = :sortBy WHERE page_index = :pageIndex')
  Future<void> updateSortSetting(int pageIndex, int sortBy);
}
