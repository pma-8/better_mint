import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextDropDown extends StatelessWidget {
  final String title;
  final List<String> items;
  final value;
  final Function function;

  TextDropDown(
      {@required this.title,
      @required this.items,
      @required this.value,
      @required this.function});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.only(top: 1.0, bottom: 1.0, right: 16.0, left: 16.0),
      title: Text(
        title,
      ),
      trailing: Container(
        child: DropdownButton(
          value: value,
          onChanged: (newValue) {
            function(newValue);
          },
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              child: Text(item),
              value: item,
            );
          }).toList(),
        ),
      ),
    );
  }
}
