import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardTotalCardBar extends StatelessWidget {
  final List<Color> colors;
  final List<double> values;

  DashboardTotalCardBar({this.colors, this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0,
      color: Colors.black,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: _buildSections(context, values, colors),
      ),
    );
  }

  List<Widget> _buildSections(
      context, List<double> percentages, List<Color> colors) {
    List<Widget> sections = List<Widget>();
    for (int i = 0; i < percentages.length; i++) {
      sections.add(
        Expanded(
          flex: int.parse("${(percentages[i] * 100).toStringAsFixed(0)}"),
          child: Container(
            color: (i == percentages.length - 1) ? Colors.grey : colors[i],
          ),
        ),
      );
    }
    return sections;
  }
}
