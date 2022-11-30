import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
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
  Collectible? collectible;

  // transformations
  Transformable container = Transformable(TileDimensions.size);
}

extension TileDebugger on Tile {
  debug() {
    print('>---');
    if (matchable != null) print('tile match: ${matchable?.match.name}');
    if (blocker != null) print('tile blocker: ${blocker?.type.name}');
    if (collectible != null) print('tile collectible: ${collectible?.type.name}');
  }
}

extension TileExploder on Tile {
  explode() {}
  getExplodingArea() {}
}
