import 'package:bettermint/business_logic/providers/add_card_provider.dart';
import 'package:bettermint/ui/widgets/text_dropdown_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoundCodeCard extends StatelessWidget {
  final AddCardProvider provider;

  FoundCodeCard({@required this.provider});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Add Card",
                    style: Theme.of(context).textTheme.headline6),
              ),
              Container(
                child: Text(provider.recognizedText,
                    style: Theme.of(context).textTheme.caption),
              ),
              TextDropDown(
                title: "Condition",
                value: provider.currentCondition,
                items: AddCardProvider.conditions,
                function: provider.setCondition,
              ),
              //TODO fetch all collection names and make it required
              provider.collections != null
                  ? TextDropDown(
                      title: "Collection",
                      value: provider.currentCollection != null
                          ? provider.currentCollection.name
                          : null,
                      items: provider.collections
                          .map((e) => e != null ? e.name : "")
                          .toList(),
                      function: provider.setCollection,
                    )
                  : Container(),
              CheckboxListTile(
                contentPadding: const EdgeInsets.only(
                    top: 1.0, bottom: 1.0, right: 16.0, left: 16.0),
                title: const Text("First Edition"),
                value: provider.firstEdition,
                onChanged: (value) => provider.setFirstEdition(value),
              ),
              CheckboxListTile(
                contentPadding: const EdgeInsets.only(
                    top: 1.0, bottom: 1.0, right: 16.0, left: 16.0),
                title: const Text("Favourite"),
                value: provider.favourite,
                onChanged: (value) => provider.setFavourite(value),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    if (!provider.pressedAddButton) {
                      provider.addCard(context);
                    }
                  },
                  child: Text("Add Card"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
