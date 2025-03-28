import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/services/api_services/yugioh_prices_api_serice.dart';
import 'package:bettermint/business_logic/services/db_services/card_collection_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:bettermint/ui/utils/scaffold_keys.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class AddCardProvider extends BaseProvider {
  List<CardCollection> collections;
  static final List<String> conditions = [
    "",
    "Poor",
    "Played",
    "Light Played",
    "Good",
    "Excellent",
    "Near Mint",
    "Mint",
  ];
  Size imageSize;
  String recognizedText = "Loading ...";
  String displayText = "";

  CardCollection currentCollection;
  String currentCondition = "";
  bool favourite = false;
  bool firstEdition = false;
  bool pressedAddButton = false;

  // Regular expression for verifying set codes
  final String pattern = r"^[A-Z0-9]{3,4}-[A-Z0-9]{0,2}[0-9]{3}";
  final String pattern2 = r"^[A-Z0-9]{3,4}-[A-Z0-9]{0,2}[A-Z0-9]{3}";
  List<TextElement> elements = [];

  final _ces = locator<CardEntityService>();
  final _ccs = locator<CardCollectionService>();

  refresh(String imagePath) async {
    await initializeVision(imagePath);
    await loadAvailableCollections();
  }

  setFirstEdition(bool pFirstEdition) {
    firstEdition = pFirstEdition;
    setState(ViewState.IDLE);
  }

  setFavourite(bool pFavourite) {
    favourite = pFavourite;
    setState(ViewState.IDLE);
  }

  setCondition(String pCondition) {
    currentCondition = pCondition;
    setState(ViewState.IDLE);
  }

  setCollection(String pCollection) {
    print("set collection $pCollection");
    if (pCollection == "") {
      return;
    }
    currentCollection =
        collections.firstWhere((element) => element.name == pCollection);

    /// TODO collection name is not unique
    setState(ViewState.IDLE);
  }

  loadAvailableCollections() async {
    setState(ViewState.BUSY);
    collections = (await _ccs.getAllCollections());
    collections.add(null);
    setState(ViewState.IDLE);
  }

  addCard(BuildContext context) async {
    pressedAddButton = true;
    setState(ViewState.BUSY);
    RegExp _setCodeRegex = RegExp(pattern);
    String setCode = _setCodeRegex.stringMatch(recognizedText);
    collections.removeWhere((element) => element == null);
    print(
        "Add Card $setCode, $favourite, $firstEdition, $currentCollection, $currentCondition");

    bool successful = true;
    String status = "Card was added.";
    // Try to add recognized card, catch http exceptions
      try {
      await _ces.addCard(
          setCode, currentCollection, favourite, currentCondition,
          firstEdition);
    } catch (e)
    {
      print("Exception while adding: " + e.toString());
      successful = false;
      if(e is PricesRequestFailed) {
        PricesRequestFailed failedRequest = e;
        status = failedRequest.toString();
        status += "\nPlease check the setcode before adding.";
      }
      else if(e is SocketException || e is HttpException) {
        status = "Services are currently unavailable.\n";
        status += "Please try again later.";
      } else {
        status = "Unknown error occurred. ";
        status += "Please try again later.";
      }
    }

    collections.removeWhere((element) => element == null);

    setState(ViewState.IDLE);

    //TODO Bad Code, should use defining names for routes
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
    showStatusSnackbar(context, status, successful);
  }

  showStatusSnackbar(BuildContext context, String status, bool successful) {
    final SnackBar addSuccessSnackbar = SnackBar(
      backgroundColor: successful ? ColorPalette.mint_green : ColorPalette.accent_red.shade300 ,
      content: Text(status),
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldKeys.mainScaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldKeys.mainScaffoldKey.currentState.showSnackBar(addSuccessSnackbar);
  }

  /// Recognize the image and get the required data from it.
  initializeVision(String path) async {
    // Retrieve image file from path
    final File imageFile = File(path);
    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    RegExp regEx = RegExp(pattern);
    RegExp regEx2 = RegExp(pattern2);

    /// Retrieve texts from VisionText and then separate out the email addresses from it.
    /// The texts are present in blocks -> lines -> text.
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        // Checking if the line contains set codes
        print(line.text);
        if (regEx.hasMatch(line.text)) {
          print("Regex1: " + displayText);
          displayText += line.text + '\n';
          for (TextElement element in line.elements) {
            elements.add(element);
          }
        } else if (regEx2.hasMatch(line.text)) {
          String firstPart = line.text.substring(0, line.text.indexOf('-'));
          String secondPart = line.text.substring(
              line.text.indexOf('-') + 1, line.text.length);

          if (regEx
              .hasMatch(firstPart + '-' + secondPart.replaceAll('O', '0'))) {
            displayText = firstPart + '-' + secondPart.replaceAll('O', '0');
            print("Regex2 :" + displayText);
            for (TextElement element in line.elements) {
              elements.add(element);
            }
          }
        }
      }
    }

    recognizedText = displayText;
    setState(ViewState.IDLE);
  }

  /// Fetch the [imageFile] with the help of its path and then retireve the size
  /// from it.
  _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(imageFile);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size tmpImageSize = await completer.future;
    imageSize = tmpImageSize;
    setState(ViewState.IDLE);
  }
}
