import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class DetailScreenCardDetails extends StatelessWidget {
  final List<List<String>> tileBuilder;

  DetailScreenCardDetails({@required this.tileBuilder});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tileBuilder[0].length,
      itemBuilder: (context, index) => ListTile(
        contentPadding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
        title: Text(
            tileBuilder[1][index],
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text(
          tileBuilder[0][index],
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      separatorBuilder: (context, index) => Divider(
        color: ColorPalette.cool_grey.shade800,
      ),
    );
  }
}
