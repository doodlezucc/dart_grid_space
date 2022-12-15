import 'dart:math';

import 'grid_base.dart';

const _oneThird = 1 / 3;
const _oneSixth = 1 / 6;
const _invSqrt3 = 0.57735026918962576450; // 1 / √3
const _vertDisH = _invSqrt3 * 2;
const _vertDisV = 0.86602540378443864676; // √3 / 2
const _twlvSqt3 = _vertDisV / 6; // √3 / 12

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
  double get tileHeightRatio => horizontal ? _vertDisH : _vertDisV;

  double get tileDistance => 2 * tileShape.innerRadius;

  HexagonalGrid(
    int tilesInRow, {
    this.horizontal = true,
    Point<U>? zero,
    Point<U>? size,
  }) : super(tilesInRow, zero: zero, size: size);

  ShiftPoint<T> _toShift<T extends num>(Point<T> p) {
    return ShiftPoint(_pShift(p), _pBase(p));
  }

  Point<T> _fromShift<T extends num>(ShiftPoint<T> p) {
    return Point(horizontal ? p.shift : p.base, horizontal ? p.base : p.shift);
  }

  T _pShift<T extends num>(Point<T> p) {
    return horizontal ? p.x : p.y;
  }

  T _pBase<T extends num>(Point<T> p) {
    return horizontal ? p.y : p.x;
  }

  @override
  Point<double> tileCenterInGrid(Point<int> tile) {
    final sh = _pShift(tile);
    final off = _fromShift(ShiftPoint(
      0.5,
      sh % 2 == 1 ? 1.0 : 0.5,
    ));

    return tile.cast<double>() + off;
  }

  @override
  Point<int> worldToTile(Point<num> worldPos) {
    final gridPoint = _toShift(Point(
      (worldPos.x - zero.x) / tileWidth,
      (worldPos.y - zero.y) / tileHeight,
    ));
    final shModPeriod = (gridPoint.shift + _oneSixth) % 2.0;
    final shMod = shModPeriod % 1.0;
    var sh = (gridPoint.shift + _oneSixth).floor();

    if (shMod < _oneThird) {
      var off = hexOffset(gridPoint.shift);
      var bMod = gridPoint.base % 1.0;

      if (bMod > 0.5) {
        bMod = 1 - bMod;
      }

      if (bMod < off == shModPeriod < 1) {
        sh -= 1;
      }
    }

    var b = (gridPoint.base - hexOffset(gridPoint.shift)).floor();
    return _fromShift(ShiftPoint(sh, b));
  }

  @override
  Point<num> snapToIntersection(Point<num> worldPos) {
    final worldPosD = worldPos.cast<double>();
    final tile = worldToTile(worldPos);
    final center = tileCenterInWorld(tile);
    final vector = worldPosD - center;
    var angle = atan2(vector.y, vector.x) + pi;
    if (!horizontal) {
      angle = pi * 15 / 6 - angle;
    }

    var angleFixed = (angle * 3 / pi).round() % 6;

    var off = _fromShift(_angleToOffset(angleFixed));
    var scaled = Point(off.x * tileWidth, off.y * tileHeight);
    return center + scaled;
  }

  ShiftPoint<double> _angleToOffset(int angle) {
    switch (angle) {
      case 0:
        return ShiftPoint(-2 * _oneThird, 0);
      case 1:
        return ShiftPoint(-_oneThird, -0.5);
      case 2:
        return ShiftPoint(_oneThird, -0.5);
      case 3:
        return ShiftPoint(2 * _oneThird, 0);
      case 4:
        return ShiftPoint(_oneThird, 0.5);
      case 5:
        return ShiftPoint(-_oneThird, 0.5);
    }
    throw RangeError.range(angle, 0, 5);
  }

  @override
  HexagonTile get tileShape =>
      horizontal ? HexagonTile.horizontal : HexagonTile.vertical;
}

class ShiftPoint<U extends num> {
  final U shift;
  final U base;

  ShiftPoint(this.shift, this.base);
}

class HexagonTile extends Tile {
  final double heightRatio;
  final double innerRadius;
  final double outerRadius;

  const HexagonTile._(
    List<Point> points, {
    required this.heightRatio,
    required this.innerRadius,
    required this.outerRadius,
  }) : super(points);

  static const horizontal = HexagonTile._(
    [
      Point(0.5 - _oneThird, 2 * _invSqrt3),
      Point(0.5 + _oneThird, 2 * _invSqrt3),
      Point(0.5 + 2 * _oneThird, _invSqrt3),
      Point(0.5 + _oneThird, 0),
      Point(0.5 - _oneThird, 0),
      Point(0.5 - 2 * _oneThird, _invSqrt3),
    ],
    heightRatio: _vertDisH,
    innerRadius: _invSqrt3,
    outerRadius: 2 / 3,
  );

  static const vertical = HexagonTile._(
    [
      Point(1, _twlvSqt3),
      Point(1, 5 * _twlvSqt3),
      Point(0.5, 7 * _twlvSqt3),
      Point(0, 5 * _twlvSqt3),
      Point(0, _twlvSqt3),
      Point(0.5, -_twlvSqt3),
    ],
    heightRatio: _vertDisV,
    innerRadius: 1 / 2,
    outerRadius: _invSqrt3,
  );
}
