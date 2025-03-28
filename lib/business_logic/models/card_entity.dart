import 'package:bettermint/business_logic/models/base_entity.dart';
import 'package:bettermint/business_logic/models/set_code.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

const String cardEntityTableName = "card";

@Entity(tableName: cardEntityTableName, foreignKeys: [
  ForeignKey(
      childColumns: ['set_code'],
      parentColumns: ['set_code'],
      entity: SetCode,
      onDelete: ForeignKeyAction.cascade)
])
class CardEntity extends BaseEntity {
  @ColumnInfo(name: 'set_code')
  String setCode;

  @ignore
  SetCode setCodeInformation;

  @ColumnInfo(name: 'favorite')
  bool favorite;

  @ColumnInfo(name: 'first_edition')
  bool firstEdition = false;

  @ColumnInfo(name: 'condition')
  String condition;

  @ignore
  List<CardEntity> duplicates = List();

  @ignore
  String latestCreateTime;

  @ignore
  bool duplicatesFav = false;

  @ignore
  Image image;

  CardEntity(
      {int id, this.setCode, this.favorite, this.condition, this.firstEdition})
      : super(id: id);
}
