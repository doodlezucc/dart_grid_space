import 'dart:math';

import 'package:grid/grid.dart';
import 'package:test/test.dart';

void main() {
  final points = [
    Point(0, 0),
    Point(1, 1),
    Point(0, 1),
    Point(1, 0),
  ];

  test('Tile Width', () {
    final grid = Grid.square<num>(4, zero: Point(0, 0), size: Point(2, 3));
    expect(grid.tilesInRow, 4);
    expect(grid.tileWidth, 0.5);
  });

  group('Square', () {
    final grid = Grid.square<num>(9, zero: Point(0, 0), size: Point(9, 9));

    test('Bijective Conversion', () {
      for (var p in points) {
        expect(grid.worldToGridSpace(grid.gridToWorldSpace(p)), matchPoint(p));
        expect(grid.gridToWorldSpace(grid.worldToGridSpace(p)), matchPoint(p));
      }
    });
  });
}

Matcher matchPoint(Point p, {double maxDistance = 0.001}) {
  return isA<Point>().having(
      (q) => pnt<double>(q).squaredDistanceTo(pnt<double>(p)),
      'Distance',
      lessThanOrEqualTo(maxDistance * maxDistance));
}
