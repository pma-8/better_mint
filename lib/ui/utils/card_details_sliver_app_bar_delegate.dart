import 'package:flutter/material.dart';

class CardDetailsSliverAppBarDelegate extends SliverPersistentHeaderDelegate{

  final TabBar tabBar;
  CardDetailsSliverAppBarDelegate({@required this.tabBar});

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: tabBar,
    );
  }
}