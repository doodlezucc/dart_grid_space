import 'dart:math';

import 'grid_base.dart';

class UnclampedGrid<U extends num> extends Grid<U> {
  double scale;

  UnclampedGrid({this.scale = 1, Point<U>? zero}) : super(zero: zero);

  @override
  Point<double> gridToWorldSpace(Point gridPos) {
    return zero.cast<double>() + gridPos.cast<double>() * scale;
  }

  @override
  Point<double> worldToGridSpace(Point worldPos) {
    return (worldPos.cast<double>() - zero.cast<double>()) * (1 / scale);
  }

  @override
  Point gridSnapCentered(Point center, int size) {
    return center;
  }

  @override
  Point worldSnapCentered(Point center, int size) {
    return center;
  }
}
