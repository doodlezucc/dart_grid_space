import 'dart:math';

import 'package:grid/grid.dart';
import 'package:test/test.dart';

void main() {
  final points = [
    Point(0, 0),
    Point(1, 0),
    Point(1, 1),
    Point(0, 1),
  ];

  test('Tile Width', () {
    final grid = Grid.square(4, zero: Point(0.5, 0.5), size: Point(2, 3));
    expect(grid.tilesInRow, 4);
    expect(grid.tileSize, 0.5);
  });

  group('Square', () {
    final grid = Grid.square(
      9,
      zero: Point(2.3, 2.65),
      size: Point(5.5, 3.4),
    );

    test('Bijective Conversion', () {
      for (var p in points) {
        expect(grid.worldToGridSpace(grid.gridToWorldSpace(p)), matchPoint(p));
        expect(grid.gridToWorldSpace(grid.worldToGridSpace(p)), matchPoint(p));
      }
    });

    test('Transform', () {
      expect(
          points.map((p) => grid.gridToWorldSpace(p)),
          matchPoints([
            grid.zero,
            grid.zero + Point(grid.tileSize, 0),
            grid.zero + Point(grid.tileSize, grid.tileSize),
            grid.zero + Point(0, grid.tileSize),
          ]));
    });
  });

  group('Hexagon', () {
    test('Triangle Wave Function', () {
      expect(triangle(0), 0);
      expect(triangle(0.5), 0.25);
      expect(triangle(1), 0.5);
      expect(triangle(1.5), 0.25);
      expect(triangle(2), 0);
      expect(triangle(2.5), 0.25);
    });

    final grid = Grid.hexagonal(
      9,
      zero: Point(2.3, 2.65),
      size: Point(5.5, 3.4),
    );

    test('Bijective Conversion', () {
      for (var p in points) {
        expect(grid.worldToGridSpace(grid.gridToWorldSpace(p)), matchPoint(p));
        expect(grid.gridToWorldSpace(grid.worldToGridSpace(p)), matchPoint(p));
      }
    });

    test('Transform', () {
      expect(
          points.map((p) => grid.gridToWorldSpace(p)),
          matchPoints([
            grid.zero,
            grid.zero + Point(grid.tileSize, 0.5 * grid.tileSize),
            grid.zero + Point(grid.tileSize, 1.5 * grid.tileSize),
            grid.zero + Point(0, grid.tileSize),
          ]));
    });
  });
}

Matcher matchPoints(List<Point> points) {
  return equals(points.map((p) => matchPoint(p)).toList());
}

Matcher matchPoint(Point p, {double maxDistance = 0.001}) {
  return isA<Point>().having(
      (q) => pnt<double>(q).squaredDistanceTo(pnt<double>(p)),
      'Distance',
      lessThanOrEqualTo(maxDistance * maxDistance));
}
