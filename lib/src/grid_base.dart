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
  double get tileWidth => size.x / tilesInRow;
  double get tileHeight => tileWidth;

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

extension PointExtension<P extends num> on Point<P> {
  Point<U> cast<U extends num>() {
    if (U == int) return Point(x.toInt() as U, y.toInt() as U);

    if (U == double) return Point(x.toDouble() as U, y.toDouble() as U);

    return Point(x as U, y as U);
  }

  Point<T> sc<T extends num>(T Function(P v) scale) {
    return Point(scale(x), scale(y));
  }
}
