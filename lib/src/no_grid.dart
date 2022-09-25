import 'dart:math';

import 'grid_base.dart';

class UnclampedGrid<U extends num> extends Grid<U> {
  double scale;

  UnclampedGrid({this.scale = 1, Point<U>? zero}) : super(zero: zero);

  @override
  Point gridToWorldSpace(Point gridPos) {
    return zero.cast<num>() + gridPos.cast<num>() * scale;
  }

  @override
  Point worldToGridSpace(Point worldPos) {
    return (worldPos.cast<num>() - zero.cast<num>()) * (1 / scale);
  }
}
