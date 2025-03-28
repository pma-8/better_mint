import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_inforamtion_card_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class CardInformationCardEntityDao
    extends BaseEntityDao<CardInformationCardEntity> {
  static const String tableName = cardInformationCardEntityTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<CardInformationCardEntity>> findAll();

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();
}
