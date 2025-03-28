import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/set_price_prices.dart';
import 'package:floor/floor.dart';

@dao
abstract class SetPricePricesDao extends BaseEntityDao<SetPricePrices> {
  static const String tableName = setPricePricesTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<SetPricePrices>> findAll();

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();
}
