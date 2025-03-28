import 'package:flutter/material.dart';

class CardDetailsSliverTabViewDelegate extends SliverPersistentHeaderDelegate{

  final TabBarView tabBarView;

  CardDetailsSliverTabViewDelegate({@required this.tabBarView});

  //Maximum Value
  @override
  double get maxExtent => 1200;

  @override
  double get minExtent => 1200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: tabBarView,
    );
  }
}