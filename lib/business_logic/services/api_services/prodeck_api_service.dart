import 'dart:async';

import 'package:bettermint/business_logic/models/card_information.dart';
import 'package:bettermint/business_logic/services/api_services/base_api_service.dart';

// ignore_for_file: unused_field
class ProdeckAPIService extends BaseAPIService {
  final cardInfoUrl = "https://db.ygoprodeck.com/api/v7/cardinfo.php";
  final cardSetUrl = "https://db.ygoprodeck.com/api/v7/cardsetsinfo.php";

  //Endpoints for cardInfoUrl description is copied from the api
  String _name = "name";                 // The exact name of the card.
  String _fname = "fname";               // A fuzzy search using a string. For example &fname=Magician to search by all cards with "Magician" in the name.
  String _id =  "id";                    //The ID of the card. You cannot pass this alongside name. You can pass multiple comma separated IDs to this parameter.
  String _type =  "type";                //The type of card you want to filter by. See below "Card Types Returned" to see all available types. You can pass multiple comma separated Types to this parameter.
  String _atk = "atk";                   //Filter by atk value.
  String _def = "def";                   //Filter by def value.
  String _level = "level";               //Filter by card level/RANK.
  String _race =  "race";                //Filter by the card race which is officially called type (Spellcaster, Warrior, Insect, etc). This is also used for Spell/Trap cards (see below). You can pass multiple comma separated Races to this parameter.
  String _attribute = "attribute";       //Filter by the card attribute. You can pass multiple comma separated Attributes to this parameter.
  String _link =  "link";                //Filter the cards by Link value.
  String _linkmarker =  "linkmarker";    //Filter the cards by Link Marker value (Top, Bottom, Left, Right, Bottom-Left, Bottom-Right, Top-Left, Top-Right). You can pass multiple comma separated values to this parameter (see examples below).
  String _scale = "scale";               //Filter the cards by Pendulum Scale value.
  String _cardset = "cardset";           //Filter the cards by card set (Metal Raiders, Soul Fusion, etc).
  String _archetype = "archetype";       //Filter the cards by archetype (Dark Magician, Prank-Kids, Blue-Eyes, etc).
  String _banlist = "banlist";           //Filter the cards by banlist (TCG, OCG, Goat).
  String _sort =  "sort";                //Sort the order of the cards (atk, def, name, type, level, id, new).
  String _format =  "format";            //Sort the format of the cards (tcg, goat, ocg goat, speed duel, rush duel, duel links). Note: Duel Links is not 100% accurate but is close. Using tcg results in all cards with a set TCG Release Date and excludes Speed Duel/Rush Duel cards.
  String _misc =  "misc";                //Show additional response info (Card Views, Beta Name, etc.).
  String _staple =  "staple";            //Check if card is a staple.
  String _hasEffect =  "has_effect";     //Check if a card actually has an effect or not by passing a boolean true/false. Examples of cards that do not have an actual effect: Black Skull Dragon, LANphorhynchus, etc etc.
  String _startdate = "startdate";       //enddate and dateregion = Query release dates for cards and the region of these release dates (TCG or OCG). What date format you pass to startdate and enddate can be slightly varied as our API picks up different formats and converts it regardless. For example: Jan 01 2000 or 01/01/2000

  //Endpoint for cardSetUrl
  String _setcode = "setcode";           //returns the following information: id, name, set_name, set_code, set_rarity and set_price (in $).

  Future<CardInformation> _fetchCardInfo(Map<String, String> paramsAndValues, {withImage=true}) async {
    final jsonBody = await super.fetchData(paramsAndValues, cardInfoUrl);
    final card = CardInformation.fromJson(jsonBody);

    if(withImage) {
      /*final b64Image = await fetchAndEncodeImage(
          jsonBody["data"][0]["card_images"][0]["image_url"]);*/ //Remark: always picks the first image should be correct when searching with ygoprodeck id
    }

    return card;
  }

  Future<CardInformation> fetchCardInfoByProDeckId(String id) {
    return _fetchCardInfo({_id: id});
  }

  Future<CardInformation> fetchCardInfoByName(String name) {
    return _fetchCardInfo({_name: name});
  }

  Future<List<CardInformation>> fetchCardInfosByName(List<String> names) async {
    var cards = List<CardInformation>();
    var cardsFuture = List<Future<CardInformation>>();

    for (int i = 0; i < names.length; i++) {
      var cardName = names[i];
      try {
        Future<CardInformation> cardFuture = fetchCardInfoByName(cardName);
        cardFuture.then((value) => cards.add(value));
        cardsFuture.add(cardFuture);
      } catch (e) {
        print("$e could not get card $cardName");
      }
    }

    await Future.wait(cardsFuture);

    return cards;
  }
}