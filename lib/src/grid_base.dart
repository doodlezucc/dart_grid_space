import 'dart:math';

import 'square_grid.dart';

abstract class Grid<U extends num> {
  Point<U> zero;
  Point<U> size;

  Grid({Point<U>? zero, Point<U>? size})
      : zero = zero ?? Point(0 as U, 0 as U),
        size = size ?? Point(1 as U, 1 as U);

  static SquareGrid<U> square<U extends num>(
    int tilesInRow, {
    Point<U>? zero,
    Point<U>? size,
  }) =>
      SquareGrid(tilesInRow, zero: zero, size: size);

  Point gridToWorldSpace(Point<U> gridPos);
  Point worldToGridSpace(Point<U> worldPos);
}

abstract class TiledGrid<U extends num> extends Grid<U> {
  final Tile tileShape;
  int tilesInRow;

  double get tileWidth => size.x / tilesInRow;

  TiledGrid(
    this.tilesInRow, {
    required this.tileShape,
    Point<U>? zero,
    Point<U>? size,
  }) : super(zero: zero, size: size);
}

abstract class Tile {
  final List<Point> points;

  const Tile(this.points);

  Point getTilePosition(Point<int> pos);
}

Point<U> pnt<U extends num>(Point p) {
  if (U == int) return Point(p.x.toInt() as U, p.y.toInt() as U);

  if (U == double) return Point(p.x.toDouble() as U, p.y.toDouble() as U);

  return Point(p.x as U, p.y as U);
}
