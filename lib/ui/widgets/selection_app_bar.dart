import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/business_logic/utils/sort_service.dart';
import 'package:bettermint/enums/view_page_enum.dart';
import 'package:bettermint/ui/screens/main_scaffold.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MainScaffoldProvider prov;
  final Widget title;
  final bool showAppbar;

  SelectionAppBar({Key key, this.title, this.showAppbar, this.prov})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: /*showAppbar ?*/ preferredSize.height /*: 0.0*/,
      duration: Duration(milliseconds: 200),
      child: AnimatedSwitcher(
          duration: kThemeAnimationDuration, child: _buildAppBar(context)),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    if (prov.getDragController().value.isSelecting) {
      return AppBar(
        key: const Key('selecting'),
        titleSpacing: 0,
        leading: const CloseButton(),
        title: Text(
            '${prov.getDragController().value.amount} item(s) selected...'),
      );
    } else {
      if (prov.isSearching) {
        return AppBar(
            key: const Key('non-selecting'),
            actions: [
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  prov.stopSearching();
                },
                color: ColorPalette.cool_grey[900],
              )
            ],
            title: _buildTextField(context));
      } else {
        return AppBar(
            key: const Key('non-selecting'),
            title: prov.getPageIndex() == ViewPage.COLLECTION_DETAIL_VIEW.index-1 ? Text(prov.selectedCollection.name) :  title,
            leading: prov.getPageIndex() == ViewPage.COLLECTION_DETAIL_VIEW.index-1 ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {
                prov.getPageController().jumpToPage(ViewPage.COLLECTION_OVERVIEW.index-1)
              },
            ): null,
            actions: [_buildIconButton(context), _buildSortButton()]);
      }
    }
  }

  Widget _buildIconButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          prov.startSearching();
        });
  }

  Widget _buildTextField(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: SCREEN_WIDTH * 0.04, bottom: SCREEN_WIDTH * 0.04),
      child: TextField(
        style: Theme.of(context).textTheme.headline6,
        controller: prov.searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: "Card Title or Setcode",
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<SortedBy>(
        initialValue: prov.getSort(prov.getPageIndex()),
        icon: Icon(Icons.sort),
        color: ColorPalette.cool_grey[900],
        onSelected: (SortedBy result) {
          prov.sort(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SortedBy>>[
              PopupMenuItem<SortedBy>(
                  value: SortedBy.dateAdded,
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Text("Date Added"),
                    Spacer(),
                    Icon(Icons.date_range, color: ColorPalette.mint_green[400]),
                  ])),
              PopupMenuItem<SortedBy>(
                  value: SortedBy.alphabetical,
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Text("Alphabetical"),
                    Spacer(),
                    Icon(Icons.sort_by_alpha,
                        color: ColorPalette.mint_green[400]),
                  ])),
              PopupMenuItem<SortedBy>(
                  value: SortedBy.marketValue,
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Text('Market Value'),
                    Spacer(),
                    Icon(Icons.attach_money,
                        color: ColorPalette.mint_green[400]),
                  ])),
              PopupMenuItem<SortedBy>(
                  value: SortedBy.favorite,
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Text('Favorite'),
                    Spacer(),
                    Icon(Icons.favorite, color: ColorPalette.mint_green[400]),
                  ])),
            ]);
  }
}
