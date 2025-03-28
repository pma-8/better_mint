import 'package:bettermint/business_logic/models/base_entity.dart';
import 'package:floor/floor.dart';

const String setPriceTableName = "set_prices";

@Entity(tableName: setPriceTableName)
class SetPrice extends BaseEntity {
  @ColumnInfo(name: 'average_price')
  double averagePrice;

  @ColumnInfo(name: 'highest_price')
  double highestPrice;

  @ColumnInfo(name: 'lowest_price')
  double lowestPrice;

  double shift;

  @ColumnInfo(name: 'shift_3')
  double shift3;

  @ColumnInfo(name: 'shift_7')
  double shift7;

  @ColumnInfo(name: 'shift_30')
  double shift30;

  @ColumnInfo(name: 'shift_90')
  double shift90;

  @ColumnInfo(name: 'shift_180')
  double shift180;

  @ColumnInfo(name: 'shift_365')
  double shift365;

  @ColumnInfo(name: 'updated_at')
  String updatedAt; //TODO needs a type converter

  @ColumnInfo(name: 'notify_price_change')
  bool notifyPriceChange;

  @ColumnInfo(name: 'notify_update_frequency')
  int notifyUpdateFrequency;

  @ColumnInfo(name: 'notify_price_change_margin')
  double notifyPriceChangeMargin;

  SetPrice({int id, this.averagePrice, this.highestPrice,
    this.lowestPrice, this.notifyPriceChange, this.notifyPriceChangeMargin,
    this.notifyUpdateFrequency, this.updatedAt,
    this.shift,
    this.shift3,
    this.shift7,
    this.shift30,
    this.shift90,
    this.shift180,
    this.shift365
  }): super(id: id);

  SetPrice.fromJson(Map<String, dynamic> json)
      : highestPrice = json["data"]["price_data"]["price_data"]["data"]["prices"]["high"],
        averagePrice = json["data"]["price_data"]["price_data"]["data"]["prices"]["average"],
        lowestPrice  = json["data"]["price_data"]["price_data"]["data"]["prices"]["low"],
        shift  = json["data"]["price_data"]["price_data"]["data"]["prices"]["shift"],
        shift3  = json["data"]["price_data"]["price_data"]["data"]["prices"]["shift_3"],
        shift7  = json["data"]["price_data"]["price_data"]["data"]["prices"]["shift_7"],
        shift30  = json["data"]["price_data"]["price_data"]["data"]["prices"]["shift_30"],
        shift90  = json["data"]["price_data"]["price_data"]["data"]["prices"]["shift_90"],
        shift180  = json["data"]["price_data"]["price_data"]["data"]["prices"]["shift_180"],
        shift365  = json["data"]["price_data"]["price_data"]["data"]["prices"]["shift_365"];

}