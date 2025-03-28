import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:io';

class BaseAPIService {
  String _paramPrefix = "?";
  String _paramSuffix = "=";
  RegExp _baseUrlRegex = RegExp(r"^.+?[^\/:](?=[?\/]|$)");
  List<String> _ignoreBaseUrls = [
    "https://yugiohprices.com"
  ];

  Map<String, Queue<DateTime>> lastRequests = Map<String, Queue<DateTime>>();

  Future<http.Response> getRequest(String url) async {

    _rateLimit(_baseUrlRegex.stringMatch(url), 19, 1500);
    final response = await http.get(url);

    print(url);

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
          "data could not be fetched! code: ${response.statusCode})");
    }

    return response;
  }

  Future<Map<String, dynamic>> fetchData(
      Map<String, String> paramsAndValues, url,
      {bool usePrefAndSuf = true}) async {
    String requestUrl = url;

    paramsAndValues.forEach((param, value) {
      requestUrl += ((usePrefAndSuf) ? _paramPrefix : "") +
          param +
          ((usePrefAndSuf) ? _paramSuffix : "") +
          value.replaceAll(RegExp(' +'), '%20');
    });

    var requestReturn = await getRequest(requestUrl);
    return jsonDecode(requestReturn.body);
  }

  Future<String> fetchAndEncodeImage(String url) async {
    Uint8List image = (await getRequest(url)).bodyBytes;
    print("size before compression ${image.lengthInBytes}");
    /*image = await FlutterImageCompress.compressWithList(
        image,
        quality: 70
    );*/
    print("size after compression ${image.lengthInBytes}");
    return base64Encode(image);
  }

  void _rateLimit(String baseUrl, int requestAmount, int milliseconds) {
    if(_ignoreBaseUrls.contains(baseUrl)){
      return;
    }

    if(lastRequests[baseUrl] == null){
      lastRequests[baseUrl] = Queue<DateTime>();
    }

    lastRequests[baseUrl].addFirst(DateTime.now());
    //print(
    //    "latest req ${lastRequests[baseUrl].first} last req ${lastRequests[baseUrl].last} diff ${lastRequests[baseUrl].first.difference(lastRequests[baseUrl].last).inMilliseconds}");
    var timePassedSinceFirstRequest = lastRequests[baseUrl]
        .first
        .difference(lastRequests[baseUrl].last)
        .inMilliseconds;

    if (timePassedSinceFirstRequest < milliseconds &&
        lastRequests[baseUrl].length == requestAmount) {
      sleep(Duration(milliseconds: milliseconds));
      lastRequests[baseUrl].clear();
    }
    if (timePassedSinceFirstRequest > milliseconds) {
      lastRequests[baseUrl].clear();
    }
  }
}
