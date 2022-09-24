import 'dart:math';

import 'grid_base.dart';

class SquareGrid<U extends num> extends TiledGrid<U> {
  SquareGrid(int tilesInRow, {Point<U>? zero, Point<U>? size})
      : super(tilesInRow, zero: zero, size: size);

  @override
  Point gridToWorldSpace(Point gridPos) {
    return pnt<double>(zero) + pnt<double>(gridPos) * tileSize;
  }

  @override
  Point worldToGridSpace(Point worldPos) {
    return (pnt<double>(worldPos) - pnt<double>(zero)) * (1 / tileSize);
  }

  @override
  Tile get tileShape => const SquareTile();
}

class SquareTile extends Tile {
  const SquareTile()
      : super(const [
          Point(0, 0),
          Point(1, 0),
          Point(1, 1),
          Point(0, 1),
        ]);

  @override
  Point<int> getTilePosition(Point<int> pos) => pos;
}
