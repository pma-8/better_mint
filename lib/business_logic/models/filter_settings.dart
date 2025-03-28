import 'package:bettermint/business_logic/models/base_entity.dart';
import 'package:floor/floor.dart';

const String filterSettingsTableName = "filter_settings";

@Entity(tableName: filterSettingsTableName)
class FilterSettings extends BaseEntity {

  @ColumnInfo(name: 'sort_by')
  int sortBy; //should be enum but doesn't work

  @ColumnInfo(name: 'page_index')
  int pageIndex;

  ///not used
  /*
  @ColumnInfo(name: 'show_duplicates')
  bool showDuplicates;
  bool ascending;
  */
  FilterSettings(
      {int id, /*this.showDuplicates, this.ascending,*/ this.sortBy, this.pageIndex})
      : super(id: id);
}

enum SORTOPTION {
  NAME,
  PRICE,
  LEVEL,
  FAVORITES,
  CARDTYPE,
  ATKPOINTS,
  DEFPOINTS,
  ATTRIBUTE,
  RACE
}
