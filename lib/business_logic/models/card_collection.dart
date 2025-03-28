import 'package:bettermint/business_logic/models/base_entity.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:floor/floor.dart';

const String cardCollectionTableName = "card_collection";

@Entity(tableName: cardCollectionTableName)
class CardCollection extends BaseEntity {
  String name;

  @ColumnInfo(nullable: false)
  bool favorite = false;

  @ignore
  double totalValue;

  @ignore
  List<CardEntity> cards;

  CardCollection({int id, this.name, this.favorite}) : super(id: id);
}
