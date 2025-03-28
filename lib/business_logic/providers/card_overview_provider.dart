import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/db_services/image_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/business_logic/utils/sort_service.dart';
import 'package:bettermint/enums/view_state_enum.dart';

class CardOverviewProvider extends BaseProvider {
  List<CardEntity> cards = [];
  List<CardEntity> cardsDuplicate = [];

  ImageService _imgs = locator<ImageService>();
  CardEntityService _ces = locator<CardEntityService>();
  SortService sortService = locator<SortService>();

  initForCollection(CardCollection collection) async {
    setState(ViewState.BUSY);
    cards = _ces.aggregateDuplicates(collection.cards);
    cardsDuplicate.clear();
    cardsDuplicate.addAll(cards);
    await fillImageCache();
    setState(ViewState.IDLE);
  }

  Future<int> refresh() async{
    setState(ViewState.BUSY);
    int res = await _ces.updatePrices();
    if(res > 0){
      await init();
    }
    setState(ViewState.IDLE);
    return res;
  }

  init() async {
    setState(ViewState.BUSY);
    await loadCards();
    await fillImageCache();
    cardsDuplicate.clear();
    cardsDuplicate.addAll(cards);
    setState(ViewState.IDLE);
  }

  loadCards() async {
    cards = await _ces.loadAllCardEntities();
  }

  fillImageCache() async {
    cards = await _imgs.getImagesFromEntities(cards);
  }


}
