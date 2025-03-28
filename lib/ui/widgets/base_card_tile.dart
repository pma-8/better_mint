import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/ui/screens/card_details_view.dart';
import 'package:flutter/material.dart';

class BaseCardTile extends StatelessWidget {
  final Image image;
  final bool tappable;
  final CardEntity entity;

  BaseCardTile({@required this.image, this.entity, this.tappable = true});

  @override
  Widget build(BuildContext context) {
    Container container = Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Theme.of(context).shadowColor,
              offset: Offset(2, 2),
              blurRadius: 2,
              spreadRadius: 0)
        ]),
        child: Container(
            child: image)
        );

    InkWell inkWell;
    if (tappable) {
      inkWell = InkWell(
        child: container,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardDetailsView(
                image: image.image,
                cardEntity: entity,
              ),
            ),
          );
        },
      );
    }

    if (inkWell != null) {
      return Stack(
        children: [inkWell],
      );
    } else {
      return Stack(
        children: [container],
      );
    }
  }
}
