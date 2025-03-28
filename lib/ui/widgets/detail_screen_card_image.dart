import 'package:flutter/material.dart';

class DetailScreenCardImage extends StatelessWidget {
  final double defaultCardWidth;
  final double defaultCardHeight;
  final double cardContainerFactor;
  final double scale;
  final Image image;

  DetailScreenCardImage({
    @required this.defaultCardHeight,
    @required this.defaultCardWidth,
    @required this.cardContainerFactor,
    @required this.image,
    @required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    //TODO Temporarily fix
    final double cardWidth = defaultCardWidth * scale;
    final double cardHeight = defaultCardHeight * scale;
    final double borderWidth = (cardWidth + cardWidth * cardContainerFactor);
    final double borderHeight = (cardHeight + cardHeight * cardContainerFactor);
    final double topVal = 20.0;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // card container widget
        PositionedDirectional(
          top: topVal,
          start: (MediaQuery.of(context).size.width - borderWidth) / 2,
          child: Container(
            child: Transform.scale(
              scale: 1 - this.cardContainerFactor,
              child: image,
            ),
            width: borderWidth,
            height: borderHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x70000000),
                    offset: Offset(5, 5),
                    blurRadius: 5,
                    spreadRadius: 0)
              ],
              gradient: LinearGradient(
                  begin: Alignment(0.03234127163887024, 0.03564453125),
                  end: Alignment(0.984920620918274, 1),
                  colors: [const Color(0xff5c667e), const Color(0xff01d9c4)]),
            ),
          ),
        ),
        // card image
        PositionedDirectional(
          top: topVal + ((borderHeight - cardHeight) / 2),
          start: (MediaQuery.of(context).size.width - cardWidth) / 2,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: const Color(0x3b000000),
                    offset: Offset(6, 6),
                    blurRadius: 5,
                    spreadRadius: 0)
              ],
            ),
          ),
        )
      ],
    );
  }
}
