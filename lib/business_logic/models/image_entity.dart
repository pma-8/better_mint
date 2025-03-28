import 'dart:convert';

import 'package:bettermint/business_logic/models/base_entity.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

const String imageTableName = "image";
@Entity(
  tableName: imageTableName
)
class ImageEntity extends BaseEntity{
  String base64Image;

  ImageEntity({int id, this.base64Image}): super(id: id);

  Image get decodedImage{
    return Image.memory(base64Decode(this.base64Image));
  }
}