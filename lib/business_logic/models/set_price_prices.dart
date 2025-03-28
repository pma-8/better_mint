import 'package:bettermint/business_logic/models/set_price.dart';
import 'package:floor/floor.dart';

const String setPricePricesTableName = "set_price_prices";

/// Maps all old prices and their dates to a set price id in order to get a
/// price history
@Entity(tableName: setPricePricesTableName, primaryKeys: [
  'set_price_id',
  'date_time'
], foreignKeys: [
  ForeignKey(
      childColumns: ['set_price_id'],
      parentColumns: ['id'],
      entity: SetPrice,
      onDelete: ForeignKeyAction.cascade)
])
class SetPricePrices {
  @ColumnInfo(name: 'set_price_id')
  int setPriceId;

  @ColumnInfo(name: 'date_time')
  String dateTime; //TODO needs a type converter

  double value;

  SetPricePrices({this.setPriceId, this.dateTime, this.value});
}
