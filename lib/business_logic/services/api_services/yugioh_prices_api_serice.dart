import 'dart:async';
import 'dart:io';

import 'package:bettermint/business_logic/models/image_entity.dart';
import 'package:bettermint/business_logic/models/set_code.dart';
import 'package:bettermint/business_logic/models/set_price.dart';
import 'package:bettermint/business_logic/services/api_services/base_api_service.dart';
import 'package:flutter/material.dart';
//import "package:threading/threading.dart";

// ignore_for_file: unused_field
class YugiohPricesAPIService extends BaseAPIService {
  String _setCodeImageUrl =
      "https://static-3.studiobebop.net/ygo_data/card_variants/";
  String _jpgSuffix = ".jpg";

  String _yugiohPricesBaseUrl = "https://yugiohprices.com/api/";
  String _price_for_print_tag = "price_for_print_tag/";

  Future<List<SetCode>> fetchSetCodes(List<String> setCodes,
      {withImage = true}) async {
    List<Future<SetCode>> setCodeObjFutures = [];
    List<SetCode> setCodeObjs = [];

    for (String setCode in setCodes) {
      var setCodeFuture =  fetchSetCode(setCode, withImage: withImage);
      if(withImage) {
        await setCodeFuture.then((value) => setCodeObjs.add(value));
      }
      else {
        setCodeFuture.then((value) => setCodeObjs.add(value)); //// needs to be awatied in order to fix a but that leads to images on the wrong setcodes
      }

      setCodeObjFutures.add(setCodeFuture);
    }

    await Future.wait(setCodeObjFutures);
    return setCodeObjs;
  }

  Future<SetCode> fetchSetCode(String setCode, {withImage = true}) async {
    Map<String, String> paramAndValue = {_price_for_print_tag: setCode};
    final jsonBody = await super
        .fetchData(paramAndValue, _yugiohPricesBaseUrl, usePrefAndSuf: false);
    print(jsonBody);

    var setCodePrice;

    if (jsonBody["status"] == "fail") {
      throw new PricesRequestFailed(failedSetCode: setCode);
    }

    setCodePrice = SetPrice.fromJson(jsonBody);
    print(setCodePrice.shift.toString());


    final setCodeObj = SetCode.fromJson(jsonBody);
    setCodeObj.setPrice = setCodePrice;

    if (withImage) {
      var imageString = await _fetchSetCodeImage(setCode);
      setCodeObj.image = ImageEntity(base64Image: imageString);
    }

    return setCodeObj;
  }

  Future<String> _fetchSetCodeImage(String setCode) async {
    return await super
        .fetchAndEncodeImage(_setCodeImageUrl + setCode + _jpgSuffix);
  }
}

class PricesRequestFailed implements Exception {

  String failedSetCode;

  PricesRequestFailed({@required this.failedSetCode});

  @override
  String toString() {
    return failedSetCode + " was not recognized by yugiohprices.com";
  }
}
