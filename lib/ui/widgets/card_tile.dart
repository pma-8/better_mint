import 'package:badges/badges.dart';
import 'package:bettermint/business_logic/models/card_entity.dart';
import 'package:bettermint/ui/screens/card_details_view.dart';
import 'package:bettermint/ui/utils/ColorPalette.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';

class CardTile extends StatefulWidget {
  final String priceChange;
  final Image image;
  final bool lost;

  final MaterialColor color;
  final bool selected;

  final Selection selection;

  final CardEntity entity;

  CardTile(
      {Key key,
      this.priceChange,
      @required this.image,
      this.lost,
      this.color,
      @required this.selected,
      @required this.selection,
      this.entity})
      : assert(selection != null),
        super(key: key);

  @override
  _CardTileState createState() => _CardTileState(image: image, entity: entity);
}

class _CardTileState extends State<CardTile>
    with SingleTickerProviderStateMixin {
  AnimationController _animController;
  Animation<double> _scaleAnim;

  Image image;
  CardEntity entity;

  _CardTileState({this.entity, this.image});

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this,
        value: widget.selected ? 1 : 0,
        duration: kThemeChangeDuration);

    _scaleAnim = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CardTile oldWidget) {
    image = oldWidget.image;
    entity = oldWidget.entity;
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) {
        return Container(
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: DecoratedBox(
              child: Stack(
                children: [
                  child,
                  widget.selected
                      ? Positioned(
                          right: -10,
                          top: -10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check_circle,
                            ),
                          ),
                        )
                      : Container(),
                  widget.entity.duplicatesFav
                      ? Positioned(
                          left: -10,
                          top: -10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.selection.isSelecting
              ? null
              : () {
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
          child: Badge(
            position: BadgePosition.bottomStart(bottom: 4.5, start: 5),
            shape: BadgeShape.square,
            //padding: EdgeInsets.all(7),
            toAnimate: false,
            showBadge: entity.duplicates.length > 1,
            badgeColor: ColorPalette.cool_grey[700],
            alignment: Alignment.center,
            badgeContent: Text(
              (entity.duplicates.length).toString(),
              style: Theme.of(context).textTheme.button,
              textAlign: TextAlign.center,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        child: image,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: -2,
                      child: Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.cool_grey[700],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorPalette.cool_grey[900],
                                spreadRadius: 0.5,
                                blurRadius: 0.5,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, top: 5, bottom: 5),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  entity.setCodeInformation.setPrice
                                          .averagePrice
                                          .toString() ??
                                      "",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color selectionColor() {
    return Color.lerp(
        widget.color.shade500, widget.color.shade900, _animController.value);
  }
}
