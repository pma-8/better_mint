import 'package:bettermint/business_logic/models/card_collection.dart';
import 'package:bettermint/business_logic/providers/collection_add_card_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_scaffold.dart';

class CollectionAddCardView extends StatelessWidget {
  final CardCollection coll;

  final double cardHeight = SCREEN_HEIGHT * 0.55;
  final TextEditingController editingController = TextEditingController();
  CollectionAddCardView({this.coll});

  @override
  Widget build(BuildContext context) {
    return BaseView<CollectionAddCardProvider>(
      onModelReady: (provider) async {
        provider.coll = coll;
        await provider.init();
      },
      builder: (context, provider, child) => provider.state == ViewState.BUSY
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: cardHeight,
                width: SCREEN_WIDTH,
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(SCREEN_HEIGHT * 0.01),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: TextField(
                                controller: editingController,
                                autofocus: true,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: "Card Title",
                                ),
                                onChanged: (input) {
                                  provider.filterSearchResults(input);
                                }),
                          ),
                          SizedBox(
                            height: SCREEN_HEIGHT * 0.01,
                          ),
                          Expanded(
                            child: Container(
                              child: ListView(
                                primary: true,
                                shrinkWrap: true,
                                children: [
                                  Wrap(
                                    spacing: 4.0,
                                    runSpacing: 4.0,
                                    children: List.generate(
                                        provider.entities.length, (index) {
                                      return ChoiceChip(
                                        key:
                                            ObjectKey(provider.entities[index]),
                                        label: Text(
                                          provider
                                              .entities[index]
                                              .setCodeInformation
                                              .cardInformation
                                              .name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        avatar:
                                            provider.entities[index].image ==
                                                    null
                                                ? Container()
                                                : CircleAvatar(
                                                    backgroundImage: provider
                                                        .entities[index]
                                                        .image
                                                        .image),
                                        selected: provider.selectedEntities
                                            .contains(provider.entities[index]),
                                        selectedColor:
                                            Theme.of(context).accentColor,
                                        onSelected: (bool selected) {
                                          provider.selectEntity(
                                              index, selected);
                                        },
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              RaisedButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Spacer(),
                              RaisedButton(
                                child: Text("Add Cards"),
                                onPressed: () async {
                                  if (provider.selectedEntities.length > 0) {
                                    await provider.addCardsToCollection();
                                    Navigator.pop(context);
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
