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
  Tile(this.key, this.matchable, this.blocker, this.collectible, this.container);
  Tile.empty() : key = UniqueKey();

  Tile clone() => Tile(key, matchable?.clone(), blocker?.clone(), collectible?.clone(), container.clone());

  // identifiers
  final Key key;

  // content
  Matchable? matchable;
  Blocker? blocker;
  Collectible? collectible;

  // transformations
  Transformable container = Transformable.fromSize(TileDimensions.size);

  setPositionFromYX(int y, int x) {
    container.position = Offset(x * TileDimensions.totalWidth, y * TileDimensions.totalHeight);
  }
}

extension TileExploder on Tile {
  explode() {}
  getExplodingArea() {}
}

extension TileDebugger on Tile {
  debug() {
    print('>---');
    String coordinates = 'x: ${container.left} y: ${container.top}';
    if (matchable != null) print('tile match: ${matchable?.match.name} $coordinates');
    if (blocker != null) print('tile blocker: ${blocker?.type.name} $coordinates');
    if (collectible != null) print('tile collectible: ${collectible?.type.name} $coordinates');
  }
}
