import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/enums/view_page_enum.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/screens/add_card_camera_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainBottomNavigationBarProvider extends BaseProvider {
  int currentPageIndex = 0;

  initCurrentPageIndex(MainScaffoldProvider scaffoldProvider) {
    if(scaffoldProvider.getPageIndex() == 4){
      currentPageIndex = scaffoldProvider.getPageIndex()-1;
    }else{
      currentPageIndex = scaffoldProvider.getPageIndex();
    }
  }

  movePage(int pIndex, PageController pPageController, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ///Close active snackbar if present needed for really deleting deleted collection
    setState(ViewState.BUSY);
    if (pIndex == ViewPage.PLACEHOLDER.index) {
      navigateToAddCardCameraView(context);
    } else if (pIndex == ViewPage.COLLECTION_OVERVIEW.index ||
        pIndex == ViewPage.OPTIONS.index) {
      currentPageIndex = pIndex;
      pPageController.jumpToPage(currentPageIndex - 1);
    } else {
      currentPageIndex = pIndex;
      pPageController.jumpToPage(currentPageIndex);
    }
    setState(ViewState.IDLE);
  }

  navigateToAddCardCameraView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardCameraView(),
      ),
    );
  }
}
