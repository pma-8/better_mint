import 'package:bettermint/business_logic/models/base_entity.dart';
import 'package:floor/floor.dart';


const String cardInformationTableName = "card_information";

@Entity(tableName: cardInformationTableName)
class CardInformation extends BaseEntity{

  @ColumnInfo(name: 'card_type')
  String cardType;

  @ColumnInfo(name: 'atk_points')
  int atkPoints;

  @ColumnInfo(name: 'def_points')
  int defPoints;

  @ColumnInfo(name: 'card_price')
  double cardPrice;

  String name;
  String description;
  int level;
  String race;
  String attribute;
  bool banned;
  bool staple;

  CardInformation({int id, this.name,this.level,this.cardType,
    this.description,this.atkPoints,this.defPoints,this.race,this.attribute,
    this.cardPrice,this.banned,this.staple}) : super(id: id);

  /// Maps only trivial information
  /// images and prices are mapped separately (see api service)
  CardInformation.fromJson(Map<String, dynamic> json)
      : name = json["data"][0]["name"],
        level = json["data"][0]["level"],
        cardType = json["data"][0]["type"],
        description = json["data"][0]["desc"],
        atkPoints = json["data"][0]["atk"],
        defPoints = json["data"][0]["def"],
        race = json["data"][0]["race"],
        attribute = json["data"][0]["attribute"],
        cardPrice = double.tryParse(
            json["data"][0]["card_prices"][0]["cardmarket_price"]);
  //TODO staple and banned misses sometimes when fetching and which card price here?
}