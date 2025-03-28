import 'package:bettermint/business_logic/providers/collection_overview_provider.dart';
import 'package:bettermint/business_logic/providers/main_scaffold_provider.dart';
import 'package:bettermint/enums/view_state_enum.dart';
import 'package:bettermint/ui/screens/collection_overview_view/collection_add_view.dart';
import 'package:bettermint/ui/screens/collection_overview_view/collection_tile.dart';
import 'package:bettermint/ui/screens/main_scaffold.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:bettermint/ui/utils/base_view.dart';
import 'package:bettermint/ui/utils/refresh_snackbar_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CollectionOverviewView extends StatefulWidget {
  final MainScaffoldProvider scaffoldProvider;

  CollectionOverviewView({@required this.scaffoldProvider});

  @override
  State<StatefulWidget> createState() =>
      _CollectionOverviewViewMain(scaffoldProvider: scaffoldProvider);
}

class _CollectionOverviewViewMain extends State<CollectionOverviewView> {
  final MainScaffoldProvider scaffoldProvider;

  _CollectionOverviewViewMain({@required this.scaffoldProvider});

  @override
  Widget build(BuildContext context) {
    return BaseView<CollectionOverviewProvider>(
      onModelDispose: (provider) async {
        await provider.teardown();
        scaffoldProvider.searchQueryController.removeListener(() =>
            provider.filterSearchResults(
                scaffoldProvider.searchQueryController.value.text));
        provider.sortService.removeListener(() {
          if (mounted) {
            setState(() {
              provider.filterSearchResults(
                  scaffoldProvider.searchQueryController.value.text);
            });
          }
        });
      },
      onModelReady: (provider) async {
        await provider.init();
        scaffoldProvider.searchQueryController.addListener(() {
          if (mounted) {
            setState(() {
              provider.filterSearchResults(
                  scaffoldProvider.searchQueryController.value.text);
            });
          }
        });
        provider.sortService
            .addListener(() => provider.sort(alterDuplicates: false));
      },
      builder: (context, provider, child) => provider.state == ViewState.BUSY
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                int res = await provider.refresh();
                RefreshSnackbarResponse.spawnSnackbar(context, res);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    //// unfocus keyboard when tapped anywhere else
                    if (MediaQuery.of(context).viewInsets.bottom != 0) {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    }
                  },
                  child: Stack(
                    children: [
                      ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: provider.collections.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ),
                                color: ColorPalette.accent_red[400],
                              ),
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                setState(() {
                                  provider.removeCollectionFromList(index);
                                });
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                      duration: Duration(seconds: 4),
                                      content: Text("Collection Removed!"),
                                      behavior: SnackBarBehavior.floating,
                                      width: SCREEN_WIDTH * 0.60,
                                      action: SnackBarAction(
                                        label: 'UNDO',
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          setState(() {
                                            provider.undoRemoval(index);
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 1),
                                            width: SCREEN_WIDTH * 0.4,
                                            content: Text(
                                              'Removal Undone!',
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                        },
                                      ),
                                    ))
                                    .closed
                                    .then((SnackBarClosedReason reason) {
                                  print(reason.toString());
                                  if (reason == SnackBarClosedReason.swipe ||
                                      reason == SnackBarClosedReason.timeout ||
                                      reason == SnackBarClosedReason.hide) {
                                    provider.deleteRemovedCollection(index);
                                  }
                                });
                              },
                              child: CollectionTile(
                                  prov: provider,
                                  collection:
                                      provider.collections[index],
                                  scaffoldProvider: scaffoldProvider),
                            );
                          }),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: SCREEN_WIDTH * 0.14),
                          child: FloatingActionButton(
                            heroTag: 'addFloatingButton',
                            mini: true,
                            onPressed: () {
                              showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CollectionAddView(
                                        provider: provider);
                                  }).whenComplete(() {
                                print("complete");
                                if (mounted) {
                                  setState(() {
                                    provider.sort(alterDuplicates: true);
                                  });
                                }
                              });
                            },
                            child: Icon(
                              Icons.add_rounded,
                              size: SCREEN_WIDTH * 0.09,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
