import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/utils/base_service.dart';

class CardInformationService extends BaseService{

  

  Future<Map<String, List<CardEntity>>> getAllCardInformations() async {
    var collections = await db.cardCollectionDao.findAll();
    var entityCollections = Map<String, List<CardEntity>>();
    for(int i = 0; i < collections.length; i++) {
      var entityCollection = await db.cardEntityDao.findByCollectionId(
          collections[i].id);
      entityCollections[collections[i].name] = entityCollection;
    }
    return entityCollections;
  }

}