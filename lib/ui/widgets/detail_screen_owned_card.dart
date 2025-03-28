import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class DetailScreenOwnedCard extends StatelessWidget {
  final Map<String, int> tileBuilder;

  DetailScreenOwnedCard({@required this.tileBuilder});

  @override
  Widget build(BuildContext context) {
    var titleConditions = tileBuilder.entries.toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tileBuilder.length,
      itemBuilder: (context, index) => ListTile(
        contentPadding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
        title: Text(
          titleConditions[index].key,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text(
          titleConditions[index].value.toString(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      separatorBuilder: (context, index) => Divider(
        color: ColorPalette.cool_grey.shade800,
      ),
    );
  }
}
