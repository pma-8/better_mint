import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/providers/duplicate_dialog_provider.dart';
import 'package:bettermint/business_logic/providers/selected_bottom_bar_provider.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:flutter/material.dart';

class DuplicateSelectionDialog extends StatelessWidget {
  final SelectedBottomBarProvider selectedBottomBarProvider;
  final List<CardEntity> duplicateEntities;
  final delete;
  final bool fav;
  final CardCollection collection;

  DuplicateSelectionDialog({
    @required this.selectedBottomBarProvider,
    @required this.duplicateEntities,
    @required this.delete,
    @required this.fav,
    this.collection
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<DuplicateDialogProvider>(
      onModelReady: (provider) =>
          provider.createCheckedBoolList(duplicateEntities),
      builder: (context, provider, child) => AlertDialog(
        title: Text(
          "Please select the Cards.",
          style: TextStyle(color: ColorPalette.cool_grey[1000]),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: provider.createDuplicateList(duplicateEntities),
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () async {
              if (delete) {
                selectedBottomBarProvider.setSuccessDelete(
                    (await provider.deleteDuplicates(duplicateEntities, coll: collection)) >= 0);
              } else {
                selectedBottomBarProvider.setSuccessAdded(
                    (await provider.favDuplicates(duplicateEntities, fav)) >= 0);
              }
              Navigator.of(context).pop();
            },
            child: Text("Confirm"),
          ),
          FlatButton(
            onPressed: () {
              selectedBottomBarProvider.setCancelAction(true);
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: ColorPalette.accent_red[300]),
            ),
          )
        ],
      ),
    );
  }
}
