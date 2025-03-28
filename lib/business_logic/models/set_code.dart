import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:bettermint/business_logic/models/image_entity.dart';
import 'package:bettermint/business_logic/models/set_price.dart';
import 'package:floor/floor.dart';

const String setCodeTableName = "set_code";
@Entity(tableName: setCodeTableName,
    foreignKeys: [
      ForeignKey(
          childColumns: ['card_information_id'],
          parentColumns: ['id'],
          entity: CardInformation,
          onDelete: ForeignKeyAction.cascade),
      ForeignKey(
          childColumns: ['set_price_id'],
          parentColumns: ['id'],
          entity: SetPrice,
          onDelete: ForeignKeyAction.cascade),
      ForeignKey(
          childColumns: ['image_id'],
          parentColumns: ['id'],
          entity: ImageEntity,
          onDelete: ForeignKeyAction.cascade)],
  )
class SetCode {
  @PrimaryKey(autoGenerate: false)
  @ColumnInfo(name: 'set_code')
  String setCode;

  @ignore
  ImageEntity image;

  @ColumnInfo(name: 'image_id')
  int imageId;

  @ColumnInfo(name: 'rarity')
  String rarity;

  @ColumnInfo(name: 'card_information_id')
  int cardInformationId;

  @ignore
  CardInformation cardInformation;

  @ColumnInfo(name: 'set_price_id')
  int setPriceId;

  @ignore
  SetPrice setPrice;

  @ColumnInfo(name: 'limited_edition')
  bool limitedEdition;

  SetCode({int id, this.setCode, this.cardInformationId, this.setPriceId, this.rarity, this.limitedEdition, this.image, this.imageId});

  SetCode.fromJson(Map<String, dynamic> json) {
    setCode = json["data"]["price_data"]["print_tag"];
    cardInformation = new CardInformation();
    cardInformation.name = json["data"]["name"];
    this.cardInformation = cardInformation;
    rarity = json["data"]["price_data"]["rarity"];
  }


}