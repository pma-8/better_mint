import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:flutter/material.dart';

class DetailScreenMarketDetails extends StatelessWidget {
  final Map<String, double> tileBuilder;

  DetailScreenMarketDetails({
    @required this.tileBuilder
  });

  @override
  Widget build(BuildContext context) {
    var font = Theme.of(context).textTheme.bodyText1;
    var titlePrices = tileBuilder.entries.toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tileBuilder.length,
      itemBuilder: (context, index) => ListTile(
        contentPadding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
        title: Text(titlePrices[index].key),
        trailing: (titlePrices[index].key.contains("Shift") ?
        Text( (titlePrices[index].value >= 0 ? "+":"") + (titlePrices[index].value*100).toStringAsFixed(2) + "%",
            style: TextStyle(
            fontFamily: font.fontFamily,
            fontSize: font.fontSize,
            color: titlePrices[index].value >= 0 ? ColorPalette.mint_green : ColorPalette.accent_red)
        ):
            Text(titlePrices[index].value.toStringAsFixed(2))),
        ),
      separatorBuilder: (context, index) => Divider(
        color: ColorPalette.cool_grey.shade800,
      ),
    );
  }
}
