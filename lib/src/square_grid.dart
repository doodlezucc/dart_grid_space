import 'dart:math';

import 'grid_base.dart';

class SquareGrid<U extends num> extends TiledGrid<U> {
  SquareGrid(int tilesInRow, {Point<U>? zero, Point<U>? size})
      : super(tilesInRow, zero: zero, size: size);

  @override
  Tile get tileShape => const SquareTile();

  @override
  Point<int> worldToTile(Point<num> worldPos) {
    return worldToGridSpace(worldPos).floor();
  }

  @override
  Point<num> snapToIntersection(Point<num> worldPos) {
    return gridToWorldSpace(worldToGridSpace(worldPos).round());
  }

  @override
  Point<double> tileCenterInGrid(Point<int> tile) {
    return tile.cast<double>() + Point(0.5, 0.5);
  }
}

class SquareTile extends Tile {
  const SquareTile()
      : super(const [
          Point(0, 0),
          Point(1, 0),
          Point(1, 1),
          Point(0, 1),
        ]);
}
