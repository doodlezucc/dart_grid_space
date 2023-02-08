import 'dart:math';

import 'package:grid_space/grid_space.dart';

void main() {
  // Vertical hex grid spanning 16 tiles in 16 horizontal units
  final grid = Grid.hexagonal(
    16,
    horizontal: false,
    size: Point(16, 16),
  );

  // Coordinates in grid space
  final circle = Circle(Point(1, 2), 2);
  circle.center = grid.gridSnapCentered(circle.center, circle.diameter).cast();

  // Coordinates in world space
  final worldPosition = grid.gridToWorldSpace(circle.center);

  print('Circle $circle is displayed at $worldPosition');
}

class Circle {
  Point<double> center;
  int diameter;

  Circle(this.center, this.diameter);

  @override
  String toString() => '{ center: $center, diameter: $diameter }';
}
