import 'dart:math';

import 'grid_base.dart';

const _oneThird = 0.33333333333333333333; // 1 / 3
const _oneSixth = _oneThird / 2; // 1 / 6
const _invSqrt3 = 0.57735026918962576450; // 1 / √3
const _halfInv3 = _invSqrt3 / 2; // 1/(2*√3)
const _vertDisH = _invSqrt3 * 2;
const _vertDisV = 0.86602540378443864676; // √3 / 2

/// A hexagon outline wave function spanning a period of 2 units.
double hexOffset(num x) {
  final mod = ((x + _oneSixth) % 2.0);
  if (mod < _oneThird) return 0.5 - mod * 1.5;
  if (mod < 1) return 0;
  if (mod < 1 + _oneThird) return (mod - 1) * 1.5;

  return 0.5;
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
        ? Point(0, hexOffset(gridPos.x))
        : Point(hexOffset(gridPos.y), 0);

    return zero.cast<double>() + Point(p.x * tileWidth, p.y * tileHeight);
  }

  @override
  Point<double> worldToGridSpace(Point<num> worldPos) {
    var sq = Point(
      (worldPos.x - zero.x) / tileWidth,
      (worldPos.y - zero.y) / tileHeight,
    );
    sq -= horizontal ? Point(0, hexOffset(sq.x)) : Point(hexOffset(sq.y), 0);
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
                Point(0.5 - _oneThird, 2 * _invSqrt3),
                Point(0.5 + _oneThird, 2 * _invSqrt3),
                Point(0.5 + 2 * _oneThird, _invSqrt3),
                Point(0.5 + _oneThird, 0),
                Point(0.5 - _oneThird, 0),
                Point(0.5 - 2 * _oneThird, _invSqrt3),
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
