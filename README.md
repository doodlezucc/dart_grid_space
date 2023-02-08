Common classes to create and convert between square grids and hexagonal grids.

In grid space, every cell has a **size of 1 unit** in width and height. Each grid can define a custom "world space". Conversion between the unit grid and a grid's world space is achieved using either `gridToWorldSpace( point )` or `worldToGridSpace( point )`.

```dart
final grid = Grid.square(
    4,                // The grid area should span 4 tiles in each row
    zero: Point(0, 0) // Grid origin in world space
    size: Point(4, 4) // Grid size in world space
);

// Alternatives with hexagonal grid
Grid.hexagonal(4, horizontal: true);
Grid.hexagonal(4, horizontal: false);

// Examples: Snapping circles (center, diameter) to the Grid
final blue   = grid.gridSnapCentered( Point(0.5, 0.5), 1 );
final green  = grid.gridSnapCentered( Point(1,   2  ), 2 );
final pink   = grid.gridSnapCentered( Point(2.5, 1.5), 1 );
final orange = grid.gridSnapCentered( Point(1.5, 3.5), 1 );

// Convert to your custom world space
final worldPosition = grid.gridToWorldSpace(blue);
```

The following figure exemplifies how the grid space is laid out in each grid type, as well as how the center of a circle can be snapped to the nearest grid point.
![Figure showing how grid space and world space correlate in square grids and horizontal or vertical hex grids](media/gridspace_worldspace.svg)
Transformations in a **_square_** grid, **_horizontal hex_** grid and **_vertical hex_** grid.
