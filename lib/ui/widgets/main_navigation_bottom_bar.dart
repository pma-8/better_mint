import 'package:bettermint/business_logic/providers/bottom_navigation_bar_provider.dart';
import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:flutter/material.dart';

class MainNavigationBottomBar extends StatelessWidget {
  final PageController currentPage;
  final MainScaffoldProvider scaffProvider;

  MainNavigationBottomBar({@required this.currentPage, @required this.scaffProvider});

  @override
  Widget build(BuildContext context) {
    return BaseView<MainBottomNavigationBarProvider>(
      onModelReady: (provider) => provider.initCurrentPageIndex(scaffProvider),
      builder: (context, provider, child) => BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: ColorPalette.cool_grey[800],
          onTap: (index){
            provider.movePage(index, currentPage, context);
            scaffProvider.stopSearching();
            },
          currentIndex: provider.currentPageIndex,
          selectedItemColor: Theme.of(context).iconTheme.color,
          selectedFontSize: 11,
          unselectedItemColor: ColorPalette.cool_grey.shade300,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.analytics),
              icon: Icon(Icons.analytics_outlined),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.amp_stories),
              icon: Icon(Icons.amp_stories_outlined),
              label: "Cards",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_rounded, size: 0),
              label: "",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.collections_bookmark),
              icon: Icon(Icons.collections_bookmark_outlined),
              label: "Collections",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.more_horiz),
              icon: Icon(Icons.more_horiz_outlined),
              label: "Options",
            ),
          ],
        ),
      ),
    );
  }
}
