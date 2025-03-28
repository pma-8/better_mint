import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/ui/screens/card_overview_view.dart';
import 'package:bettermint/ui/screens/collection_overview_view/collection_detail_view.dart';
import 'package:bettermint/ui/screens/collection_overview_view/collection_overview_view.dart';
import 'package:bettermint/ui/screens/dashboard_view/dashboard_view.dart';
import 'package:bettermint/ui/screens/options_view.dart';
import 'package:flutter/material.dart';

class MainPageView extends StatelessWidget {
  final MainScaffoldProvider scaffoldProvider;

  MainPageView({@required this.scaffoldProvider});

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (int page) => scaffoldProvider.setPageIndex(page),
      controller: scaffoldProvider.getPageController(),
      children: [
        DashboardView(),
        CardOverviewView(
          scaffoldProvider: scaffoldProvider,
        ),
        CollectionOverviewView(
            scaffoldProvider: scaffoldProvider),
        OptionsView(),
        CollectionDetailView(scaffoldProvider: scaffoldProvider)
      ],
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
