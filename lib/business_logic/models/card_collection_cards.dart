import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:floor/floor.dart';

const String cardCollectionCardsTableName = "card_collection_cards";

///Maps cards to a card collection
@Entity(tableName: cardCollectionCardsTableName, primaryKeys: [
  'card_collection_id',
  'card_entity_id'
], foreignKeys: [
  ForeignKey(
      childColumns: ['card_collection_id'],
      parentColumns: ['id'],
      entity: CardCollection,
      onDelete: ForeignKeyAction.cascade),
  ForeignKey(
      childColumns: ['card_entity_id'],
      parentColumns: ['id'],
      entity: CardEntity,
      onDelete: ForeignKeyAction.cascade)
])
class CardCollectionCards {
  @ColumnInfo(name: 'card_collection_id')
  int cardCollectionId;

  @ColumnInfo(name: 'card_entity_id')
  int cardEntityId;

  CardCollectionCards({this.cardCollectionId, this.cardEntityId});
}
