import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/db_services/image_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/business_logic/utils/sort_service.dart';
import 'package:bettermint/enums/view_page_enum.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:flutter/material.dart';

class CollectionOverviewProvider extends BaseProvider {
  CardCollectionService _ccs = locator<CardCollectionService>();
  CardEntityService _ces = locator<CardEntityService>();
  ImageService _imgs = locator<ImageService>();
  SortService sortService = locator<SortService>();

  List<CardCollection> collections = List();
  List<CardCollection> collectionsDuplicate = List();

  ///for adding a collection
  List<CardEntity> allEntities;

  Map<int, double> collectionPrices = Map();
  Map<int, List<Image>> collectionPreviewImages = Map();
  Map<int, CardCollection> _lastRemoved = Map();

  Future<int> refresh() async{
    int res = await _ces.updatePrices();
    if(res > 0){
      await init();
    }
    return res;
  }

  init() async {
    setState(ViewState.BUSY);
    await getCardCollectionCards();
    await getCollectionPrices();
    await getCollectionPreviewImages();
    await getAllEntities();
    await getAllImages();
    sort(alterDuplicates: true);
    setState(ViewState.IDLE);
  }

  getAllImages() async {
    allEntities = await _imgs.getImagesFromEntities(allEntities);
  }

  getAllEntities() async {
    allEntities = await _ces.loadAllCardEntities(aggregated: false);
    List<int> ids = await _ccs.getAllCardIdsInCollections();
    allEntities = allEntities.where((element) => !ids.contains(element.id)).toList();
    /*collections.forEach((coll) {
      var cards = coll.cards;
      cards.forEach((card) {
        allEntities.removeWhere((element) => element.id == card.id);
      });
    });*/
  }

  Future<void> getCollectionPreviewImages() async {
    collectionPreviewImages =
        await _ccs.getCollectionPreviewImages(collections, 3);
  }

  getCardCollectionCards() async {
    collections = await _ccs.getAllCollections();
    collectionsDuplicate.addAll(collections);
  }

  Future<void> changeFavStatus(int id) async {
    CardCollection coll = collections.firstWhere((element) => element.id == id);
    coll.favorite = !coll.favorite;
    collectionsDuplicate.firstWhere((element) => element.id == id).favorite =
        coll.favorite;
    await _ccs.changeFavState(id);
  }

  getCollectionPrices() {
    collectionPrices.clear();
    for (CardCollection col in collections) {
      if (col != null) {
        col.totalValue = _ccs.getPriceOfCollection(col.id);
      }
    }
  }

  Future<double> getPriceOfCollection(int collectionId) async {
    return _ccs.getPriceOfCollection(collectionId);
  }

  Future<void> addCollection(String collectionName) async {
    setState(ViewState.BUSY);
    await _ccs.addNewCollection(collectionName);
    await init();
    setState(ViewState.IDLE);
  }

  Future<void> addCollectionWithCards(
      String collectionName, List<CardEntity> cards) async {
    setState(ViewState.BUSY);
    await _ccs.addNewCollectionWithCards(
        collectionName, cards);
    await init();
    setState(ViewState.IDLE);
  }

  removeCollectionFromList(int index) async {
    _lastRemoved[index] = collections.elementAt(index);
    collectionsDuplicate.remove(_lastRemoved[index]);
    collections.removeAt(index);
  }

  void undoRemoval(int index) {
    collections.insert(index, _lastRemoved[index]);
    collectionsDuplicate.insert(index, _lastRemoved[index]);
    _lastRemoved.remove(index);
  }

  Future<void> deleteRemovedCollection(int index) async {
    if (_lastRemoved[index] != null) {
      int id = _lastRemoved[index].id;
      collectionPreviewImages.remove(id);
      collectionPrices.remove(id);
      await _ccs.deleteCollection(_lastRemoved[index]);
      _lastRemoved.remove(index);
      await getAllEntities();
    }
  }

  teardown() async {
    List<CardCollection> colls = _lastRemoved.values.toList();
    for (CardCollection coll in colls) {
      await _ccs.deleteCollection(coll);
    }
  }

  void filterSearchResults(String query) {
    List<CardCollection> dummySearchList = List();
    dummySearchList.addAll(collectionsDuplicate);

    if (query.isNotEmpty) {
      List<CardCollection> dummyListData = List();
      dummySearchList.forEach((coll) {
        if (coll.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(coll);
        }
      });
      collections.clear();
      collections.addAll(dummyListData);
      return;
    } else {
      collections.clear();
      collections.addAll(collectionsDuplicate);
    }
    sort(alterDuplicates: false);
  }

  sort({bool alterDuplicates = true}) {
    switch (sortService.getSortedBy(ViewPage.COLLECTION_OVERVIEW.index-1)) {
      case SortedBy.dateAdded:
        collections.sort((a, b) {
          DateTime aDateTime = DateTime.parse(a.createTime);
          DateTime bDateTime = DateTime.parse(b.createTime);
          return bDateTime.compareTo(aDateTime);
        });
        break;
      case SortedBy.alphabetical:
        collections.sort((a, b) {
          return a.name.compareTo(b.name);
        });
        break;
      case SortedBy.marketValue:
        collections.sort((a, b) {
          return b.totalValue.compareTo(a.totalValue);
        });
        break;
      case SortedBy.favorite:
        collections.sort((a, b) {
          return a.favorite ? -1 : 1;
        });
    }
    if (alterDuplicates) {
      collectionsDuplicate.clear();
      collectionsDuplicate.addAll(collections);
    }
  }
}
