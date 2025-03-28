import 'package:bettermint/business_logic/services/api_services/dummy_data_service.dart';
import 'package:bettermint/business_logic/services/db_services/card_entity_service.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/sort_service.dart';
import 'package:bettermint/ui/screens/main_scaffold.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    setupLocator();
    await locator<DummyDataService>().startDatabase();
    await locator<CardEntityService>().loadAllCardEntities();
    await locator<SortService>().init();
    // Retrieve the device cameras
    cameras = await availableCameras();
  } on Exception catch (e) {
    print(e);
  }
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BetterMint',
      theme: ThemeData(
        canvasColor: ColorPalette.cool_grey[900],
        selectedRowColor: ColorPalette.cool_grey[700],
        primarySwatch: ColorPalette.mint_green,
        backgroundColor: ColorPalette.cool_grey[900],
        scaffoldBackgroundColor: ColorPalette.cool_grey.shade900,
        accentColor: ColorPalette.mint_green,
        buttonColor: ColorPalette.mint_green,
        primaryTextTheme: Typography.whiteCupertino,
        shadowColor: Color(0x4f000000),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(
          color: ColorPalette.mint_green[300]
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          actionTextColor:  ColorPalette.cool_grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: ColorPalette.mint_green,
          contentTextStyle: TextStyle(
            color: ColorPalette.cool_grey[700],
            fontWeight: FontWeight.bold
          )
        ),
        cardTheme: CardTheme(
            /// clipBehavior: Clip.antiAlias, apply only if content overflows edges
            margin: EdgeInsets.all(20),
            color: ColorPalette.cool_grey.shade800,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                side: BorderSide(
                    color: ColorPalette.mint_green.shade800, width: 0.5)),
            shadowColor: Color(0x4f000000),
            elevation: 5),
        textTheme: Typography.whiteCupertino,
      ),
      //darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MainScaffold(),
    );
  }
}
