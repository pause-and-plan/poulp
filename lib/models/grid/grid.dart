import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/grid/transformation.dart';
import 'package:poulp/singletons/dimensions.dart';

class Grid extends Equatable {
  static int width = 9;
  static int height = 9;
  static Point<int>? getNextCoordinates(Point<int> point) {
    var next = point + const Point(1, 0);
    if (Grid.isCoordinateInGrid(next)) return next;
    next = Point(0, point.y + 1);
    if (Grid.isCoordinateInGrid(next)) return next;
    return null;
  }

  static Point<int>? getCoordinateFromPosition(Offset position) {
    Point<int> point = Point(
      ((position.dx / dimensions.gridWidth) * Grid.width).toInt(),
      ((position.dy / dimensions.gridHeight) * Grid.height).toInt(),
    );
    if (!isCoordinateInGrid(point)) return null;
    return point;
  }

  static bool isCoordinateInGrid(Point<int> point) {
    if (point.y < 0 || Grid.height <= point.y) {
      return false;
    }
    if (point.x < 0 || Grid.width <= point.x) {
      return false;
    }
    return true;
  }

  static Grid empty() => Grid({}, {});

  const Grid(this._pointToTile, this._tileToPoint);

  Grid clone({Map<Point<int>, Key>? pointToTile, Map<Key, Point<int>>? tileToPoint}) {
    return Grid(
      Map.from(pointToTile ?? _pointToTile),
      Map.from(tileToPoint ?? _tileToPoint),
    );
  }

  Grid unmodifiable({Map<Point<int>, Key>? pointToTile, Map<Key, Point<int>>? tileToPoint}) {
    return Grid(
      Map.unmodifiable(pointToTile ?? _pointToTile),
      Map.unmodifiable(tileToPoint ?? _tileToPoint),
    );
  }

  final Map<Point<int>, Key> _pointToTile;
  final Map<Key, Point<int>> _tileToPoint;

  @override
  List<Object?> get props => [_pointToTile, _tileToPoint];
}

extension GridHelperGetter on Grid {
  _tryToGetSideTile(Key tile, Point<int> translation) {
    try {
      var point = getCoordinates(tile);
      if (point == null) {
        throw ErrorDescription("getLeftTile - tile $tile not found");
      }
      return getTile(point + translation);
    } catch (_) {
      return null;
    }
  }

  Key? getLeftTile(Key tile) => _tryToGetSideTile(tile, const Point<int>(-1, 0));
  Key? getTopTile(Key tile) => _tryToGetSideTile(tile, const Point<int>(0, -1));
  Key? getRightTile(Key tile) => _tryToGetSideTile(tile, const Point<int>(1, 0));
  Key? getBottomTile(Key tile) => _tryToGetSideTile(tile, const Point<int>(0, 1));
  Key? getSideTileByDelta(Key tile, Offset delta) {
    if (delta.dx.abs() > delta.dy.abs()) {
      return delta.dx.isNegative ? getLeftTile(tile) : getRightTile(tile);
    } else {
      return delta.dy.isNegative ? getTopTile(tile) : getBottomTile(tile);
    }
  }

  Key? getTile(Point<int> point) {
    if (!Grid.isCoordinateInGrid(point)) {
      throw ErrorDescription('getTile - $point is outside the grid');
    }
    return _pointToTile[point];
  }

  Point<int>? getCoordinates(Key tile) => _tileToPoint[tile];
}

extension GridHelperSetter on Grid {
  _setTileAt({required Point<int> at, required Key? value}) {
    if (!Grid.isCoordinateInGrid(at)) {
      throw ErrorDescription('_setTileAt - $at is outside the grid');
    }

    if (value == null) {
      _pointToTile.remove(at);
      return;
    }
    _pointToTile[at] = value;
  }

  _setPointAt({required Key at, required Point<int>? value}) {
    if (value == null) {
      _tileToPoint.remove(at);
      return;
    }
    _tileToPoint[at] = value;
  }

  _insertTile(Key tile, Point<int> point) {
    if (!Grid.isCoordinateInGrid(point)) {
      throw ErrorDescription('_insertTile - $point is outside the grid');
    }
    _setTileAt(at: point, value: tile);
    _setPointAt(at: tile, value: point);
  }
}

extension TilesTransformerSetter on Grid {
  Point<int>? removeTile(Key tile) {
    var point = getCoordinates(tile);
    if (point == null) {
      throw ErrorDescription("removeTile - tile not found");
    }

    _setTileAt(at: point, value: null);
    _setPointAt(at: tile, value: null);
    return point;
  }

  updateTile(Key tile, Point<int> to) {
    if (getTile(to) != null) {
      throw ErrorDescription("updateTile - $tile overriding existing tile ${getTile(to)} at $to");
    }
    if (getCoordinates(tile) != null) {
      removeTile(tile);
    }
    _insertTile(tile, to);
  }

  moveTile(Key tile, Point<int> translation) {
    var from = getCoordinates(tile);
    if (from == null) {
      throw ErrorDescription("moveTile - tile not found");
    }
    var to = Point<int>(from.x + translation.x, from.y + translation.y);
    if (getTile(to) != null) {
      throw ErrorDescription("moveTile - overriding existing tile");
    }
    removeTile(tile);
    _insertTile(tile, to);
  }

  Map<Key, Point<int>> swapTiles(Key tileA, Key tileB) {
    var pointB = getCoordinates(tileA);
    var pointA = getCoordinates(tileB);

    if (pointA == null || pointB == null) {
      throw ErrorDescription("swapTiles - tile not found");
    }

    removeTile(tileA);
    removeTile(tileB);
    _insertTile(tileA, pointA);
    _insertTile(tileB, pointB);

    Map<Key, Point<int>> translations = {};
    translations[tileA] = pointA - pointB;
    translations[tileB] = pointB - pointA;
    return translations;
  }
}

extension GridDebugger on Grid {
  debug() {
    String message = '';
    for (var y = 0; y < Grid.height; y++) {
      for (var x = 0; x < Grid.width; x++) {
        message += '${getTile(Point(x, y))}';
      }
      message += '\n';
    }
    print('\n------grid------\n$message\n');
  }
}
