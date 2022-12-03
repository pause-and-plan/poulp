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
  List<Tile> tiles = [];
  int score = 0;
  int movesLeft = 0;
}

extension TileSwapper on Game {
  getTileByOffset(Offset offset) {
    return tiles.firstWhere((element) => element.container.isColliding(offset));
  }

  getSideTileByDelta(Tile tile, Offset delta) {
    Offset offset = tile.container.sideCollisionFromDelta(delta);
    return getTileByOffset(offset);
  }

  swapTiles(Tile from, Tile to) {
    from.container.transform(
      translate: to.container.position - from.container.position,
      duration: swapAnimations.successDuration,
    );
    to.container.transform(
      translate: from.container.position - to.container.position,
      duration: swapAnimations.successDuration,
    );
  }
}
