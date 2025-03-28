import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/providers/card_overview_provider.dart';
import 'package:bettermint/business_logic/services/service_locator.dart';
import 'package:bettermint/business_logic/utils/base_provider.dart';
import 'package:bettermint/business_logic/utils/sort_service.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/screens/add_card_camera_view.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScaffoldProvider extends BaseProvider {
  int _pageIndex = 0;
  PageController _currentPage;
  DragSelectGridViewController _dragController;
  ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  bool isSearching = false;
  List<CardEntity> cards = [];
  CardOverviewProvider cardOverviewProvider;

  TextEditingController searchQueryController = TextEditingController();
  SortService _sortService = locator<SortService>();

  CardCollection selectedCollection;

  setCards(List<CardEntity> pCards){
    cards = pCards;
  }

  sort(SortedBy sort){
    _sortService.setSortedBy(_pageIndex, sort);
    scheduleRebuild();
  }

  SortedBy getSort(int idx){
    return _sortService.getSortedBy(idx);
  }

  startSearching(){
    isSearching = true;
    scheduleRebuild();
  }

  stopSearching(){
    isSearching = false;
    searchQueryController.clear();
    scheduleRebuild();
  }

  getPageIndex() {
    return _pageIndex;
  }

  setPageIndex(int pIndex) {
    _pageIndex = pIndex;
    _showAppbar = true;
    isScrollingDown = false;
    stopSearching();
  }

  bool getShowAppBar(){
    return _showAppbar;
  }

  ScrollController getScrollViewController(){
    return _scrollViewController;
  }

  PageController getPageController() {
    return _currentPage;
  }

  DragSelectGridViewController getDragController() {
    return _dragController;
  }

  initializeController() {
    _dragController = DragSelectGridViewController();
    _dragController.addListener(scheduleRebuild);
    _currentPage = PageController(initialPage: 0);
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      /*if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(ViewState.IDLE);
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          SetState(ViewState.IDLE);
        }
      }*/
    });
  }

  disposeController() {
    _dragController.removeListener(scheduleRebuild);
    _dragController.dispose();
    _currentPage.dispose();
    _scrollViewController.removeListener(() {});
    _scrollViewController.dispose();
  }

  scheduleRebuild() {
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
