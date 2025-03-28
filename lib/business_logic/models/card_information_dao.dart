import 'package:bettermint/business_logic/models/base_entity_dao.dart';
import 'package:bettermint/business_logic/models/card_inforamtion_card_entity.dart';
import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:floor/floor.dart';

@dao
abstract class CardInformationDao extends BaseEntityDao<CardInformation> {
  static const String tableName = cardInformationTableName;

  @Query('SELECT * FROM $tableName')
  Future<List<CardInformation>> findAll();

  @Query('SELECT * FROM $tableName WHERE id = :id')
  Future<CardInformation> findById(int id);

  @Query('SELECT * FROM $tableName WHERE id IN (:ids)')
  Future<List<CardInformation>> findByIds(List<int> id);

  @Query('SELECT * FROM $tableName WHERE name = (:name)')
  Future<List<CardInformation>> findByName(String name);

  /// Returns card information of a cardEntity
  @Query(
      'SELECT * FROM $tableName a JOIN $cardInformationCardEntityTableName b ON a.id = b.card_information_id WHERE b.card_entity_id = :cardEntityId')
  Future<CardInformation> findByCardEntityId(int cardEntityId);

  /// Returns card informations of multiple cardEntities can contain duplicates
  @Query(
      'SELECT * FROM $tableName a JOIN $cardInformationCardEntityTableName b ON a.id = b.card_information_id WHERE b.card_entity_id IN (:cardEntityIds)')
  Future<List<CardInformation>> findByCardEntityIds(List<int> cardEntityIds);

  @Query('DELETE FROM $tableName')
  Future<void> clearTable();

  @Query('DELETE FROM $tableName WHERE id = :id')
  Future<CardInformation> deleteById(int id);
}
