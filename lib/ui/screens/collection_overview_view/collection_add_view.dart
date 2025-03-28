import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/business_logic/providers/collection_overview_provider.dart';
import 'package:bettermint/ui/screens/main_scaffold.dart';
import 'package:flutter/material.dart';

class CollectionAddView extends StatefulWidget {
  final CollectionOverviewProvider provider;

  CollectionAddView({this.provider});

  @override
  State<StatefulWidget> createState() => _CollectionAddViewState(
      provider: provider, cardHeight: SCREEN_HEIGHT * 0.4);
}

class _CollectionAddViewState extends State<CollectionAddView> {
  int currentStep = 0;
  String newCollectionName;
  final CollectionOverviewProvider provider;
  List<Step> steps;
  double cardHeight;

  List<CardEntity> duplicateEntities = List();
  List<CardEntity> entities = List();
  List<CardEntity> selectedEntities = List();

  TextEditingController editingController = TextEditingController();

  _CollectionAddViewState({this.provider, this.cardHeight}) {
    duplicateEntities = provider.allEntities;
  }

  @override
  void initState() {
    entities.addAll(duplicateEntities);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<CardEntity> dummySearchList = List<CardEntity>();
    dummySearchList.addAll(duplicateEntities);
    if (query.isNotEmpty) {
      List<CardEntity> dummyListData = List<CardEntity>();
      dummySearchList.forEach((card) {
        if (card.setCodeInformation.cardInformation.name
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(card);
        }
      });
      setState(() {
        entities.clear();
        entities.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        entities.clear();
        entities.addAll(duplicateEntities);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    steps = [
      Step(
        title: Text("Title"),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                autofocus: true,
                maxLength: 20,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText:
                      newCollectionName != null && newCollectionName.isNotEmpty
                          ? newCollectionName
                          : "Collection Title",
                ),
                onChanged: (input) {
                  setState(() {
                    newCollectionName = input;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      Step(
          title: Text("Cards"),
          content: Container(
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
                        filterSearchResults(input);
                      }),
                ),
                SizedBox(
                  height: SCREEN_HEIGHT * 0.01,
                ),
                Container(
                  height: SCREEN_HEIGHT * 0.20,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: List.generate(entities.length, (index) {
                          return ChoiceChip(
                            key: ObjectKey(entities[index]),
                            label: Text(
                              entities[index]
                                  .setCodeInformation
                                  .cardInformation
                                  .name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            avatar: entities[index].image != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        entities[index].image.image)
                                : Container(),
                            selected:
                                selectedEntities.contains(entities[index]),
                            selectedColor: Theme.of(context).accentColor,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedEntities.add(entities[index]);
                                } else {
                                  selectedEntities.remove(entities[index]);
                                }
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
    ];

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: cardHeight,
        width: SCREEN_WIDTH,
        child: Card(
          child: Container(
            margin: EdgeInsets.all(SCREEN_HEIGHT * 0.01),
            child: Stepper(
              physics: const NeverScrollableScrollPhysics(),
              type: StepperType.horizontal,
              currentStep: currentStep,
              onStepCancel: () => cancel(),
              onStepTapped: (step) => goTo(step),
              onStepContinue: () => next(),
              steps: steps,
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          currentStep == 1 ? Spacer() : Container(),
                          currentStep == 1
                              ? RaisedButton(
                                  child: Text("Back"),
                                  onPressed: onStepCancel,
                                )
                              : Container(),
                          currentStep == 1 ? Spacer(flex: 2) : Container(),
                          RaisedButton(
                            child: Text("Next"),
                            onPressed: (newCollectionName != null &&
                                    newCollectionName.isNotEmpty)
                                ? onStepContinue
                                : null,
                          ),
                          currentStep == 1 ? Spacer() : Container()
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  next() {
    if (currentStep + 1 != steps.length) {
      goTo(currentStep + 1);
    } else {
      if (newCollectionName != null) {
        if (selectedEntities.isNotEmpty) {
          provider.addCollectionWithCards(newCollectionName, selectedEntities);
        } else {
          provider.addCollection(newCollectionName);
        }
        Navigator.pop(context);
      }
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() {
      if (step == 0) {
        cardHeight = SCREEN_HEIGHT * 0.4;
      } else {
        cardHeight = SCREEN_HEIGHT * 0.58;
      }
      currentStep = step;
    });
  }
}
