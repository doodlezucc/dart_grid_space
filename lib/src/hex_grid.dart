import 'dart:math';

import 'grid_base.dart';

const _invSqrt3 = 0.57735026918962576450; // 1/√3

/// A triangle wave function that linearly goes from 0 to 0.5 to 0
/// in a period of 2 units.
double triangle(num x) {
  final mod = x % 2.0;
  if (mod > 1) {
    return 1 - 0.5 * mod;
  }
  return 0.5 * mod;
}

class HexagonalGrid<U extends num> extends TiledGrid<U> {
  bool horizontal;

  HexagonalGrid(
    int tilesInRow, {
    this.horizontal = true,
    Point<U>? zero,
    Point<U>? size,
  }) : super(tilesInRow, zero: zero, size: size);

  @override
  Point<double> gridToWorldSpace(Point<num> gridPos) {
    var p = pnt<double>(gridPos);
    p += horizontal
        ? Point(0, triangle(gridPos.x))
        : Point(triangle(gridPos.y), 0);
    return pnt<double>(zero) + p * tileSize;
  }

  @override
  Point<double> worldToGridSpace(Point<num> worldPos) {
    var sq = (pnt<double>(worldPos) - pnt<double>(zero)) * (1 / tileSize);
    sq -= horizontal ? Point(0, triangle(sq.x)) : Point(triangle(sq.y), 0);
    return sq;
  }

  @override
  Tile get tileShape =>
      horizontal ? HexagonTile.horizontal : HexagonTile.vertical;
}

class HexagonTile extends Tile {
  const HexagonTile._(bool horizontal)
      : super(horizontal
            ? const [
                Point(-_invSqrt3, 1),
                Point(_invSqrt3, 1),
                Point(2 * _invSqrt3, 0),
                Point(_invSqrt3, -1),
                Point(-_invSqrt3, -1),
                Point(-2 * _invSqrt3, 0),
              ]
            : const [
                Point(1, -_invSqrt3),
                Point(1, _invSqrt3),
                Point(0, 2 * _invSqrt3),
                Point(-1, _invSqrt3),
                Point(-1, -_invSqrt3),
                Point(0, -2 * _invSqrt3),
              ]);

  static const horizontal = HexagonTile._(true);
  static const vertical = HexagonTile._(false);
}
