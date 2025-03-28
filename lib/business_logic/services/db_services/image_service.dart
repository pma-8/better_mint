import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/utils/base_service.dart';
import 'package:flutter/material.dart';

class ImageService extends BaseService {
  Map<int, Image> _imageCache = Map<int, Image>();

  /// updates cache of images by removing already deleted entities
  /// and adding such images that wherent cached before
  ///
  /// Remark: Caches images entity wise so entities with the same
  /// image will be cached twice
  Future<void> _updateImageCache(List<CardEntity> entities) async {
      List<CardEntity> entitiesToCache = List();

      entities.forEach((element) {
        if (!_imageCache.keys.contains(element.id)) {
          entitiesToCache.add(element);
        }
      });

      if(entitiesToCache.isEmpty){
        return;
      }

      final imagesToCache = await db.imageEntityDao.findByIds(
          entitiesToCache.map((e) => e.setCodeInformation.imageId).toList());

      for(int i = 0; i < imagesToCache.length; i++){
        _imageCache[entitiesToCache[i].id] = imagesToCache[i].decodedImage;
      }
  }

  Future<List<CardEntity>> getImagesFromEntities(List<CardEntity> entities) async {
    await _updateImageCache(entities);

    entities.forEach((entity) {
      entity.image = (_imageCache[entity.id]);
    });
    return entities;
  }

  Future<Image> getImageFromEntity(CardEntity entity) async {
    await _updateImageCache([entity]);
    return _imageCache[entity];
  }
}
