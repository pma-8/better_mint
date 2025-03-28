import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:floor/floor.dart';

const String cardInformationCardEntityTableName =
    "card_information_card_entity";

@Entity(tableName: cardInformationCardEntityTableName, primaryKeys: [
  'card_information_id',
  'card_entity_id'
], foreignKeys: [
  ForeignKey(
      childColumns: ['card_information_id'],
      parentColumns: ['id'],
      entity: CardInformation,
      onDelete: ForeignKeyAction.restrict),
  ForeignKey(
      childColumns: ['card_entity_id'],
      parentColumns: ['id'],
      entity: CardEntity,
      onDelete: ForeignKeyAction.cascade),
])
class CardInformationCardEntity {
  @ColumnInfo(name: 'card_information_id')
  int cardInformationId;

  @ColumnInfo(name: 'card_entity_id')
  int cardEntityId;

  CardInformationCardEntity({this.cardEntityId, this.cardInformationId});
}
