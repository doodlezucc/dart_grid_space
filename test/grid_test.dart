import 'dart:math';

import 'package:grid/grid.dart';
import 'package:test/test.dart';

void main() {
  final points = [
    Point(0, 0),
    Point(1, 0),
    Point(1, 1),
    Point(0, 1),
    Point(0.5, 0.5),
    Point(-0.5, -1.5),
  ];

  group('Utils', () {
    test('Point Rounding', () {
      expect(Point(-1.7, 1.3).round(), matchPoint(Point(-2, 1)));
    });

    test('Tile Width', () {
      final grid = Grid.square(4, zero: Point(0.5, 0.5), size: Point(2, 3));
      expect(grid.tilesInRow, 4);
      expect(grid.tileWidth, 0.5);
    });
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
            grid.zero + Point(0.5 * grid.scale, 0.5 * grid.scale),
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
            grid.zero + Point(0.5 * grid.tileWidth, 0.5 * grid.tileHeight),
            grid.zero + Point(-0.5 * grid.tileWidth, -1.5 * grid.tileHeight),
          ]));
    });
  });

  group('Hexagon', () {
    test('Wave Function', () {
      expect(hexOffset(0), closeTo(0.25));
      expect(hexOffset(0.5), closeTo(0));
      expect(hexOffset(1), closeTo(0.25));
      expect(hexOffset(1.5), closeTo(0.5));
      expect(hexOffset(2), closeTo(0.25));
      expect(hexOffset(2.5), closeTo(0));
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
              grid.zero + Point(0, 0.25 * grid.tileHeight),
              grid.zero + Point(grid.tileWidth, 0.25 * grid.tileHeight),
              grid.zero + Point(grid.tileWidth, 1.25 * grid.tileHeight),
              grid.zero + Point(0, 1.25 * grid.tileHeight),
              grid.zero + Point(0.5 * grid.tileWidth, 0.5 * grid.tileHeight),
              grid.zero + Point(-0.5 * grid.tileWidth, -grid.tileHeight),
            ]));
      });

      final unitGrid = Grid.hexagonal<double>(1, horizontal: true);
      final h = unitGrid.tileHeight;

      test('Snap to Tile', () {
        expect(unitGrid.worldToTile(Point(0.5, h * 0.5)), Point(0, 0));
        expect(unitGrid.worldToTile(Point(0, 0)), Point(-1, -1));
        expect(unitGrid.worldToTile(Point(1, 0)), Point(1, -1));
        expect(unitGrid.worldToTile(Point(1, h)), Point(1, 0));

        expect(unitGrid.worldToTile(Point(1, h * 0.25)), Point(1, -1));
        expect(unitGrid.worldToTile(Point(1, h * 0.5)), Point(0, 0));
        expect(unitGrid.worldToTile(Point(1, h * 0.75)), Point(1, 0));
      });

      test('Snap to Intersection', () {
        expect(
          unitGrid.snapToIntersection(Point(0.3, h * 0.2)),
          matchPoint(Point(1 / 6, 0)),
        );
        expect(
          unitGrid.snapToIntersection(Point(0.7, h * 0.2)),
          matchPoint(Point(5 / 6, 0)),
        );
        expect(
          unitGrid.snapToIntersection(Point(1, h * 0.5)),
          matchPoint(Point(7 / 6, h * 0.5)),
        );
        expect(
          unitGrid.snapToIntersection(Point(1, h)),
          matchPoint(Point(5 / 6, h)),
        );
        expect(
          unitGrid.snapToIntersection(Point(0, h)),
          matchPoint(Point(1 / 6, h)),
        );
        expect(
          unitGrid.snapToIntersection(Point(1.7, h * 2.4)),
          matchPoint(Point(11 / 6, h * 2.5)),
        );
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
              grid.zero + Point(0.25 * grid.tileWidth, 0),
              grid.zero + Point(1.25 * grid.tileWidth, 0),
              grid.zero + Point(1.25 * grid.tileWidth, grid.tileHeight),
              grid.zero + Point(0.25 * grid.tileWidth, grid.tileHeight),
              grid.zero + Point(0.5 * grid.tileWidth, 0.5 * grid.tileHeight),
              grid.zero + Point(-0.5 * grid.tileWidth, -1.5 * grid.tileHeight),
            ]));
      });
    });
  });
}

Matcher closeTo(double v, {double maxDistance = 0.001}) => isA<num>()
    .having((x) => (x - v).abs(), 'Error', lessThanOrEqualTo(maxDistance));

Matcher matchPoints(List<Point> points) {
  return equals(points.map((p) => matchPoint(p)).toList());
}

Matcher matchPoint(Point p, {double maxDistance = 0.001}) {
  return isA<Point>().having(
      (q) => q.cast<double>().squaredDistanceTo(p.cast<double>()),
      'Distance',
      lessThanOrEqualTo(maxDistance * maxDistance));
}
