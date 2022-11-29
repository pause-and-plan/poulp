import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/transformable.dart';

class TileDimensions {
  static double height = 44;
  static double width = 40;
  static double margin = 2;
  static double get totalHeight => height + margin;
  static double get totalWidth => width + margin;
  static Size get size => Size(width, height);
}

class Tile {
  // identifiers
  final Key key = UniqueKey();

  // content
  Matchable? matchable;
  Blocker? blocker;

  // transformations
  Transformable container = Transformable(TileDimensions.size);
}

extension TileExploder on Tile {
  explode() {}
  getExplodingArea() {}
}
