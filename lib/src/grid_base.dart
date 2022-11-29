import 'dart:math';

import 'hex_grid.dart';
import 'no_grid.dart';
import 'square_grid.dart';

abstract class Grid<U extends num> {
  Point<U> zero;
  Point<U> size;

  Grid({Point<U>? zero, Point<U>? size})
      : zero = zero ?? Point(0.cast(), 0.cast()),
        size = size ?? Point(1.cast(), 1.cast());

  static UnclampedGrid<U> unclamped<U extends num>({
    double scale = 1,
    Point<U>? zero,
  }) =>
      UnclampedGrid(scale: scale);

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

  Point<num> gridSnapCentered(Point center, int size);
  Point<num> worldSnapCentered(Point center, int size);
  Point<double> gridToWorldSpace(Point gridPos);
  Point<double> worldToGridSpace(Point worldPos);
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

  @override
  Point gridSnapCentered(Point center, int size) {
    if (size % 2 == 1) {
      return tileCenterInGrid(worldToTile(gridToWorldSpace(center)));
    } else {
      return worldToGridSpace(snapToIntersection(gridToWorldSpace(center)));
    }
  }

  @override
  Point worldSnapCentered(Point center, int size) {
    if (size % 2 == 1) {
      return tileCenterInWorld(worldToTile(center));
    } else {
      return snapToIntersection(center);
    }
  }

  @override
  Point<double> gridToWorldSpace(Point gridPos) {
    return zero.cast<double>() +
        Point(gridPos.x * tileWidth, gridPos.y * tileHeight);
  }

  @override
  Point<double> worldToGridSpace(Point worldPos) {
    final off = (worldPos.cast<double>() - zero.cast<double>());
    return Point(off.x / tileWidth, off.y / tileHeight);
  }

  Point<double> tileCenterInWorld(Point<int> tile) {
    return gridToWorldSpace(tileCenterInGrid(tile));
  }

  Point<double> tileCenterInGrid(Point<int> tile);
  Point<int> worldToTile(Point<num> worldPos);
  Point<num> snapToIntersection(Point<num> worldPos);
}

abstract class Tile {
  final List<Point> points;

  const Tile(this.points);
}

extension NumExtension on num {
  U cast<U extends num>() {
    if (U == int) return toInt() as U;
    if (U == double) return toDouble() as U;
    return this as U;
  }
}

extension PointExtension<P extends num> on Point<P> {
  Point<U> cast<U extends num>() {
    return Point(x.cast<U>(), y.cast<U>());
  }

  Point<int> round() {
    return Point(x.round(), y.round());
  }

  Point<int> floor() {
    return Point(x.floor(), y.floor());
  }

  Point<double> floorToDouble() {
    return Point(x.floorToDouble(), y.floorToDouble());
  }
}
