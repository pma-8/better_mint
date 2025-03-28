import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/ui/widgets/main_navigation_bottom_bar.dart';
import 'package:bettermint/ui/widgets/selected_bottom_bar.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';

class SelectionBottomBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Selection selection;
  final PageController currentPage;
  final MainScaffoldProvider scaffoldProvider;

  SelectionBottomBar(
      {Key key,
      this.selection = const Selection.empty(),
      this.currentPage,
      @required this.scaffoldProvider})
      : assert(selection != null),
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kBottomNavigationBarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: scaffoldProvider.getDragController().value.isSelecting
          ? SelectedBottomBar(
              scaffoldProvider: scaffoldProvider,
            )
          : MainNavigationBottomBar(
              currentPage: scaffoldProvider.getPageController(),
              scaffProvider: scaffoldProvider,
            ),
    );
  }
}
