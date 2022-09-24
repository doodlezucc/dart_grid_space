import 'dart:math';

import 'hex_grid.dart';
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

  static HexagonalGrid<U> hexagonal<U extends num>(
    int tilesInRow, {
    bool horizontal = true,
    Point<U>? zero,
    Point<U>? size,
  }) =>
      HexagonalGrid(tilesInRow, horizontal: horizontal, zero: zero, size: size);

  Point gridToWorldSpace(Point<U> gridPos);
  Point worldToGridSpace(Point<U> worldPos);
}

abstract class TiledGrid<U extends num> extends Grid<U> {
  int tilesInRow;
  double get tileSize => size.x / tilesInRow;

  Tile get tileShape;

  TiledGrid(
    this.tilesInRow, {
    Point<U>? zero,
    Point<U>? size,
  }) : super(zero: zero, size: size);
}

abstract class Tile {
  final List<Point> points;

  const Tile(this.points);
}

Point<U> pnt<U extends num>(Point p) {
  if (U == int) return Point(p.x.toInt() as U, p.y.toInt() as U);

  if (U == double) return Point(p.x.toDouble() as U, p.y.toDouble() as U);

  return Point(p.x as U, p.y as U);
}
