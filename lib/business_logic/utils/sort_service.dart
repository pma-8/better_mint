import 'package:bettermint/business_logic/models/filter_settings.dart';
import 'package:bettermint/business_logic/utils/base_service.dart';
import 'package:bettermint/enums/view_page_enum.dart';
import 'package:flutter/cupertino.dart';

class SortService extends ChangeNotifier with BaseService{
  Map<int, SortedBy> _sortedBy = Map();

  init()async{
    List<FilterSettings> settings = await db.filterSettingsDao.findAll();
    if(settings == null){
      settings = List();
      for(int i = 0; i < ViewPage.values.length; i++){
        _sortedBy[i] = SortedBy.dateAdded;
        settings.add(FilterSettings(pageIndex: i, sortBy: 0));
      }
      await db.filterSettingsDao.insertEntities(settings);
    }else{
      settings.forEach((element) {
        _sortedBy[element.pageIndex] = _getSortedByByInt(element.sortBy);
      });
    }
  }


  setSortedBy(int pageIndex, SortedBy sort){
    _sortedBy[pageIndex] = sort;
    notifyListeners();
    db.filterSettingsDao.findByPageIndex(pageIndex).then((value) {
      var settings = value;
      if(settings == null){
        settings = FilterSettings(sortBy: sort.index, pageIndex: pageIndex);
        db.filterSettingsDao.insertEntity(settings);
      }else{
        db.filterSettingsDao.updateSortSetting(settings.pageIndex, settings.sortBy);
      }
    });
  }

  SortedBy getSortedBy(int idx) => _sortedBy[idx];

  SortedBy _getSortedByByInt(int index){
    switch(index){
      case 0:
        return SortedBy.dateAdded;
        break;
      case 1:
        return SortedBy.alphabetical;
        break;
      case 2:
        return SortedBy.marketValue;
        break;
      case 3:
        return SortedBy.favorite;
        break;
    }
  }
}

enum SortedBy{
  dateAdded, /// default ordering --> the way the cards get retrieved from the database
  alphabetical,
  marketValue,
  favorite,
}