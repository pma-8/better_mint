import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:floor/floor.dart';

@DatabaseView(
    'SELECT '
            'id AS cardId, favorite AS fav ' +
        'FROM $cardEntityTableName',
    viewName: 'card_favs '
        'WHERE fav = true')
class CardFavoritesView {
  final int cardId;
  final bool fav;
  CardFavoritesView({this.cardId, this.fav});
}

@DatabaseView(
    'SELECT '
    'id AS collectionId, favorite AS fav '
    'FROM $cardCollectionTableName '
    'WHERE fav = true',
    viewName: 'collection_favs')
class CollectionFavoritesView {
  final int collectionId;
  final bool fav;
  CollectionFavoritesView({this.collectionId, this.fav});
}
