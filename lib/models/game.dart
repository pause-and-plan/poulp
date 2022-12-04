import 'package:flutter/material.dart';
import 'package:poulp/singletons/animations.dart';
import 'package:poulp/singletons/random.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/tiles.dart';
import 'package:poulp/repositories/levels/level.dart';

class Game {
  Game(this.level, this.tiles, this.score, this.movesLeft);
  Game.fromLevel(this.level) {
    random.init(level.randomSeed);
    tiles.initFromLevel(level);
  }

  Game clone() => Game(level, tiles.clone(), score, movesLeft);

  Level level;
  Map<Key, Tile> tiles = {};
  int score = 0;
  int movesLeft = 0;
}

extension TileSwapper on Game {
  getTileByOffset(Offset offset) {
    return tiles.values.firstWhere((element) => element.container.isColliding(offset));
  }

  getSideTileByDelta(Tile tile, Offset delta) {
    Offset offset = tile.container.sideCollisionFromDelta(delta);
    return getTileByOffset(offset);
  }

  bool canSwapTiles(Tile from, Tile to) {
    swapTiles(from, to, Duration.zero);
    bool containMatch = tiles.containMatch();
    revertSwap(from, to, Duration.zero);
    return containMatch;
  }

  swapTiles(Tile from, Tile to, Duration duration, {double translatePercent = 1}) {
    from.container.transform(
      translate: (to.container.position - from.container.position) * translatePercent,
      duration: duration,
    );
    to.container.transform(
      translate: (from.container.position - to.container.position) * translatePercent,
      duration: duration,
    );
  }

  revertSwap(Tile from, Tile to, Duration duration, {double translatePercent = 1}) {
    from.container.transform(
      translate: (from.container.position - to.container.position) * translatePercent,
      duration: duration,
    );
    to.container.transform(
      translate: (to.container.position - from.container.position) * translatePercent,
      duration: duration,
    );
  }

  fakeSwapToShowFailure(Tile from, Tile to, Duration duration) {
    swapTiles(from, to, duration, translatePercent: 0.4);
  }

  revertFakeSwap(Tile from, Tile to, Duration duration) {
    revertSwap(from, to, duration, translatePercent: 0.4);
  }

  flattenTiles(Tile from, Tile to) {
    from.container.flatten();
    to.container.flatten();
  }
}
