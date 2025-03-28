import 'package:bettermint/business_logic/services/db_services/db.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:collection/collection.dart';

class BaseService{
  DB _db;

  DB get db{
    if(_db == null) {
      _db = locator<DB>();
    }
    return _db;
  }

  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
}