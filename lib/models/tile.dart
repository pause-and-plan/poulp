import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/singletons/dimensions.dart';

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
  Transformable container = Transformable.fromSize(dimensions.tileSize);

  setPositionFromYX(int y, int x) {
    container.position = dimensions.tilePosition(x, y);
  }

  Color? get color => matchable?.color() ?? blocker?.color();

  MapEntry<Key, Tile> toMapEntry() => MapEntry(key, this);
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
