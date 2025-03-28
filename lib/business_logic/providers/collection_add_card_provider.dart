import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';

class CollectionAddCardProvider extends BaseProvider {

  CardEntityService _ces = locator<CardEntityService>();
  CardCollectionService _ccs = locator<CardCollectionService>();

  List<CardEntity> allCards = [];
  List<CardEntity> duplicateEntities = [];
  List<CardEntity> entities = [];
  List<CardEntity> selectedEntities = [];

  CardCollection coll;

  init() async {
    setState(ViewState.BUSY);
    entities.addAll((await getEntitiesThatAreNotInCollection()));
    duplicateEntities.addAll(entities);
    setState(ViewState.IDLE);
  }

  Future<List<CardEntity>> getEntitiesThatAreNotInCollection() async{
    List<int> cardInCollectionIds = await _ccs.getAllCardIdsInCollections();
    allCards = await _ces.loadAllCardEntities(aggregated: false);
    List<CardEntity> cardsNotInCollection = [];
    cardsNotInCollection.addAll(allCards.where((element) => !cardInCollectionIds.contains(element.id)));
    return cardsNotInCollection;
  }

  void filterSearchResults(String query) {
    List<CardEntity> dummySearchList = List<CardEntity>();
    dummySearchList.addAll(duplicateEntities);
    if (query.isNotEmpty) {
      List<CardEntity> dummyListData = List<CardEntity>();
      dummySearchList.forEach((card) {
        if (card.setCodeInformation.cardInformation.name
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(card);
        }
      });
      entities.clear();
      entities.addAll(dummyListData);
      setState(ViewState.IDLE);
      return;
    } else {
      entities.clear();
      entities.addAll(duplicateEntities);
      setState(ViewState.IDLE);
    }
  }

  void selectEntity(int index, bool selected) {
    if (selected) {
      selectedEntities.add(entities[index]);
    } else {
      selectedEntities.remove(entities[index]);
    }
    setState(ViewState.IDLE);
  }

  void refreshScreen(){
    setState(ViewState.IDLE);
  }

  Future<int> addCardsToCollection() async{
    setState(ViewState.BUSY);
    await _ccs.addCardsToCollection(selectedEntities, coll);
    setState(ViewState.IDLE);
  }
}
