import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';

class SelectionFloatButton extends StatelessWidget{
  final Selection selection;
  final String tooltip;
  final double elevation;
  final Widget child;
  final VoidCallback onPressed;

  const SelectionFloatButton({
    Key key,
    this.selection,
    this.tooltip,
    this.elevation,
    this.child,
    this.onPressed,
  })  : assert(selection != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: selection.isSelecting
          ? null
          : FloatingActionButton(
              onPressed: onPressed,
              tooltip: tooltip,
              elevation: elevation,
              child: child,
            ),
    );
  }
}
