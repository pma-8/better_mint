import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/enums/view_page_enum.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:bettermint/ui/utils/scaffold_keys.dart';
import 'package:bettermint/ui/widgets/selection_app_bar.dart';
import 'package:bettermint/ui/widgets/main_page_view.dart';
import 'package:bettermint/ui/widgets/selection_bottom_bar.dart';
import 'package:bettermint/ui/widgets/selection_float_button.dart';
import 'package:flutter/material.dart';

double SCREEN_HEIGHT;
double SCREEN_WIDTH;

class MainScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SCREEN_HEIGHT = MediaQuery.of(context).size.height;
    SCREEN_WIDTH = MediaQuery.of(context).size.width;
    return BaseView<MainScaffoldProvider>(
      onModelReady: (provider) => provider.initializeController(),
      onModelDispose: (provider) => provider.disposeController(),
      builder: (context, provider, child) => SafeArea(
        child: ScaffoldMessenger(
          key: ScaffoldKeys.mainScaffoldKey,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            primary: true,
            extendBody: true,
            appBar: provider.getPageIndex() == ViewPage.CARD_OVERVIEW.index ||
                    provider.getPageIndex() ==
                        ViewPage.COLLECTION_OVERVIEW.index - 1 ||
              provider.getPageIndex() == 4
                ? SelectionAppBar(
                    title: const Text('BETTERMINT'),
                    showAppbar: provider.getShowAppBar(),
                    prov: provider,
                  )
                //TODO: Placeholder for other Screens
                : AppBar(
                    title: const Text('BETTERMINT'),
                  ),
            body: MainPageView(
              scaffoldProvider: provider,
            ),
            bottomNavigationBar: SelectionBottomBar(
              scaffoldProvider: provider,
            ),
            floatingActionButton: SelectionFloatButton(
              selection: provider.getDragController().value,
              tooltip: 'Add Card',
              elevation: 4.0,
              child: Icon(Icons.camera_alt_outlined),
              onPressed: () => provider.navigateToAddCardCameraView(context),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        ),
      ),
    );
  }
}
