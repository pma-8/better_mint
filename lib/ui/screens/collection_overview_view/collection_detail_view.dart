import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/ui/screens/card_overview_view.dart';
import 'package:flutter/material.dart';

class CollectionDetailView extends StatelessWidget{
  MainScaffoldProvider scaffoldProvider;

  CollectionDetailView({this.scaffoldProvider});

  @override
  Widget build(BuildContext context) {
    return CardOverviewView(
        scaffoldProvider: scaffoldProvider,
        collection: scaffoldProvider.selectedCollection);
  }
}