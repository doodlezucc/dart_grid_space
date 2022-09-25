import 'dart:math';

import 'grid_base.dart';

const _oneThird = 0.33333333333333333333; // 1 / 3
const _invSqrt3 = 0.57735026918962576450; // 1 / √3
const _halfInv3 = _invSqrt3 / 2; // 1/(2*√3)
const _vertDisH = _invSqrt3 * 2;
const _vertDisV = 0.86602540378443864676; // √3 / 2

/// A triangle wave function that linearly goes from 0 to 1 to 0
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

  @override
  double get tileHeight => tileWidth * (horizontal ? _vertDisH : _vertDisV);

  HexagonalGrid(
    int tilesInRow, {
    this.horizontal = true,
    Point<U>? zero,
    Point<U>? size,
  }) : super(tilesInRow, zero: zero, size: size);

  @override
  Point<double> gridToWorldSpace(Point<num> gridPos) {
    var p = gridPos.cast<double>();
    p += horizontal
        ? Point(0, triangle(gridPos.x))
        : Point(triangle(gridPos.y), 0);

    return zero.cast<double>() + Point(p.x * tileWidth, p.y * tileHeight);
  }

  @override
  Point<double> worldToGridSpace(Point<num> worldPos) {
    var sq = Point(
      (worldPos.x - zero.x) / tileWidth,
      (worldPos.y - zero.y) / tileHeight,
    );
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
                Point(0.5 - _oneThird, 0.5 + _invSqrt3),
                Point(0.5 + _oneThird, 0.5 + _invSqrt3),
                Point(0.5 + 2 * _oneThird, 0.5),
                Point(0.5 + _oneThird, 0.5 - _invSqrt3),
                Point(0.5 - _oneThird, 0.5 - _invSqrt3),
                Point(0.5 - 2 * _oneThird, 0.5),
              ]
            : const [
                Point(1, 0.5 - _halfInv3),
                Point(1, 0.5 + _halfInv3),
                Point(0.5, 0.5 + 2 * _halfInv3),
                Point(0, 0.5 + _halfInv3),
                Point(0, 0.5 - _halfInv3),
                Point(0.5, 0.5 - 2 * _halfInv3),
              ]);

  static const horizontal = HexagonTile._(true);
  static const vertical = HexagonTile._(false);
}
