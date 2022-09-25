import 'dart:math';

import 'package:grid/grid.dart';
import 'package:test/test.dart';

void main() {
  final points = [
    Point(0, 0),
    Point(1, 0),
    Point(1, 1),
    Point(0, 1),
    Point(-0.5, -1.5),
  ];

  test('Tile Width', () {
    final grid = Grid.square(4, zero: Point(0.5, 0.5), size: Point(2, 3));
    expect(grid.tilesInRow, 4);
    expect(grid.tileWidth, 0.5);
  });

  group('Unclamped', () {
    final grid = Grid.unclamped(
      scale: 2.5,
      zero: Point(2.3, 2.65),
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
            grid.zero + Point(grid.scale, 0),
            grid.zero + Point(grid.scale, grid.scale),
            grid.zero + Point(0, grid.scale),
            grid.zero + Point(-0.5 * grid.scale, -1.5 * grid.scale),
          ]));
    });
  });

  group('Square', () {
    final grid = Grid.square(
      9,
      zero: Point(2.3, 2.65),
      size: Point(5.5, 3.4),
    );

    test('Tile Size', () {
      expect(grid.tileWidth, grid.tileHeight);
    });

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
            grid.zero + Point(grid.tileWidth, 0),
            grid.zero + Point(grid.tileWidth, grid.tileHeight),
            grid.zero + Point(0, grid.tileHeight),
            grid.zero + Point(-0.5 * grid.tileWidth, -1.5 * grid.tileHeight),
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

    group('Horizontal', () {
      final grid = Grid.hexagonal(
        9,
        horizontal: true,
        zero: Point(2.3, 2.65),
        size: Point(5.5, 3.4),
      );

      test('Bijective Conversion', () {
        for (var p in points) {
          expect(
              grid.worldToGridSpace(grid.gridToWorldSpace(p)), matchPoint(p));
          expect(
              grid.gridToWorldSpace(grid.worldToGridSpace(p)), matchPoint(p));
        }
      });

      test('Transform', () {
        expect(
            points.map((p) => grid.gridToWorldSpace(p)),
            matchPoints([
              grid.zero,
              grid.zero + Point(grid.tileWidth, 0.5 * grid.tileHeight),
              grid.zero + Point(grid.tileWidth, 1.5 * grid.tileHeight),
              grid.zero + Point(0, grid.tileHeight),
              grid.zero + Point(-0.5 * grid.tileWidth, -1.25 * grid.tileHeight),
            ]));
      });
    });

    group('Vertical', () {
      final grid = Grid.hexagonal(
        9,
        horizontal: false,
        zero: Point(2.3, 2.65),
        size: Point(5.5, 3.4),
      );

      test('Bijective Conversion', () {
        for (var p in points) {
          expect(
              grid.worldToGridSpace(grid.gridToWorldSpace(p)), matchPoint(p));
          expect(
              grid.gridToWorldSpace(grid.worldToGridSpace(p)), matchPoint(p));
        }
      });

      test('Transform', () {
        expect(
            points.map((p) => grid.gridToWorldSpace(p)),
            matchPoints([
              grid.zero,
              grid.zero + Point(grid.tileWidth, 0),
              grid.zero + Point(1.5 * grid.tileWidth, grid.tileHeight),
              grid.zero + Point(0.5 * grid.tileWidth, grid.tileHeight),
              grid.zero + Point(-0.25 * grid.tileWidth, -1.5 * grid.tileHeight),
            ]));
      });
    });
  });
}

Matcher matchPoints(List<Point> points) {
  return equals(points.map((p) => matchPoint(p)).toList());
}

Matcher matchPoint(Point p, {double maxDistance = 0.001}) {
  return isA<Point>().having(
      (q) => q.cast<double>().squaredDistanceTo(p.cast<double>()),
      'Distance',
      lessThanOrEqualTo(maxDistance * maxDistance));
}
