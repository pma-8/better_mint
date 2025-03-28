import 'package:bettermint/ui/screens/dashboard_view/dashboard_total_card_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardTotalCard extends StatelessWidget {
  final double totalValue;
  final List<Color> colors;
  final List<double> percentages;

  DashboardTotalCard(this.totalValue, this.colors, this.percentages);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Container(
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Row(children: [
            Text("TOTAL VALUE", style: Theme.of(context).textTheme.headline5)
          ]),
          Row(children: [
            Text(DateFormat('yyyy.MM.dd kk:mm').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyText2)
          ]),
          Spacer(),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("\$${totalValue.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.headline4)
                    ]),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text("", //TODO: HOW MUCH CHANGED SINCE UPDATE
                      style: Theme.of(context).textTheme.bodyText1)
                ]),
              ],
            ),
          ),
          Spacer(flex: 3),
          this.percentages != null && this.percentages.isNotEmpty ?
          DashboardTotalCardBar(colors: colors, values: percentages):Container()
        ]),
      ),
    );
  }
}
