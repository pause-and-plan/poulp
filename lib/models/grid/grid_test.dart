import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poulp/models/grid/grid.dart';

void main() {
  test('Grid coordinates limits', () {
    expect(Grid.isCoordinateInGrid(const Point(-1, 0)), false); // left out
    expect(Grid.isCoordinateInGrid(const Point(0, -1)), false); // top out
    expect(Grid.isCoordinateInGrid(const Point(9, 8)), false); // right out
    expect(Grid.isCoordinateInGrid(const Point(8, 9)), false); // bottom out

    expect(Grid.isCoordinateInGrid(const Point(0, 0)), true); // top left in
    expect(Grid.isCoordinateInGrid(const Point(8, 8)), true); // bottom right in
  });

  test('Grid clone', () {
    var grid = Grid.empty();
    var clone = grid.clone();

    Key tile = UniqueKey();
    var coordinates00 = const Point(0, 0);
    grid.updateTile(tile, coordinates00);

    expect(grid.getTile(coordinates00), tile);
    expect(grid.getCoordinates(tile), coordinates00);

    expect(clone.getTile(coordinates00), null);
    expect(clone.getCoordinates(tile), null);
  });

  test('Add tile to grid', () {
    var grid = Grid.empty();
    Key tile = UniqueKey();

    var coordinates00 = const Point(0, 0);
    grid.updateTile(tile, coordinates00);

    expect(grid.getTile(coordinates00), tile);
    expect(grid.getCoordinates(tile), coordinates00);

    var coordinates01 = const Point(0, 1);
    grid.updateTile(tile, coordinates01);

    expect(grid.getTile(coordinates00), null);
    expect(grid.getTile(coordinates01), tile);
    expect(grid.getCoordinates(tile), coordinates01);
  });

  test('Swap tiles', () {
    var grid = Grid.empty();

    Key tileA = UniqueKey();
    Key tileB = UniqueKey();
    var coordinatesA = const Point(0, 0);
    var coordinatesB = const Point(0, 1);

    grid.updateTile(tileA, coordinatesA);
    grid.updateTile(tileB, coordinatesB);
    grid.swapTiles(tileA, tileB);

    expect(grid.getTile(coordinatesA), tileB);
    expect(grid.getTile(coordinatesB), tileA);
    expect(grid.getCoordinates(tileA), coordinatesB);
    expect(grid.getCoordinates(tileB), coordinatesA);
  });

  test('Get side tiles', () {
    var grid = Grid.empty();

    Key tileCenter = UniqueKey();
    Key tileLeft = UniqueKey();
    Key tileTop = UniqueKey();
    Key tileRight = UniqueKey();
    Key tileBottom = UniqueKey();

    var coordinatesCenter = const Point(1, 1);
    var coordinatesLeft = const Point(0, 1);
    var coordinatesTop = const Point(1, 0);
    var coordinatesRight = const Point(2, 1);
    var coordinatesBottom = const Point(1, 2);

    grid.updateTile(tileCenter, coordinatesCenter);
    grid.updateTile(tileLeft, coordinatesLeft);
    grid.updateTile(tileTop, coordinatesTop);
    grid.updateTile(tileRight, coordinatesRight);
    grid.updateTile(tileBottom, coordinatesBottom);

    expect(grid.getLeftTile(tileCenter), tileLeft);
    expect(grid.getTopTile(tileCenter), tileTop);
    expect(grid.getRightTile(tileCenter), tileRight);
    expect(grid.getBottomTile(tileCenter), tileBottom);

    expect(grid.getLeftTile(tileLeft), null); // get tile outside the grid
  });
}
