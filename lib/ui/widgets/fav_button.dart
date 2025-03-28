import 'package:flutter/material.dart';

class FavButton extends StatefulWidget {
  final bool isFav;
  final int id;
  final Future<void> Function(int) changeFavStatus;

  FavButton({this.id, this.isFav, this.changeFavStatus});

  @override
  State<StatefulWidget> createState() {
    return _FavButton(id: id, isFav: isFav, changeFavStatus: changeFavStatus);
  }
}

class _FavButton extends State<FavButton> {
  bool isFav;
  final int id;
  final Future<void> Function(int) changeFavStatus;

  _FavButton({this.id, this.isFav, this.changeFavStatus});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.favorite),
        splashColor: Theme.of(context).accentColor,
        splashRadius: 20,
        highlightColor: isFav
            ? Theme.of(context).backgroundColor
            : Theme.of(context).accentColor,
        color: isFav
            ? Theme.of(context).accentColor
            : Theme.of(context).backgroundColor,
        onPressed: () {
          setState(() {
            changeFavStatus(id);
            isFav = !isFav;
          });
        } //isFav ? unFavorite: doFavorite,
        );
  }
}
