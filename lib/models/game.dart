import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/matching_group.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/singletons/animations.dart';
import 'package:poulp/singletons/dimensions.dart';
import 'package:poulp/singletons/random.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/tiles.dart';
import 'package:poulp/repositories/levels/level.dart';

class Game {
  static Game fromLevel(Level level) {
    randomProvider.init(level.randomSeed);
    return Game(level, TilesGenerator.initFromLevel(level), [], 0, level.movesLeft);
  }

  const Game(this.level, this.tiles, this.spawns, this.score, this.movesLeft);

  Game clone({Level? level, Map<Key, Tile>? tiles, List<List<Tile>>? spawns, int? score, int? movesLeft}) {
    return Game(
      level ?? this.level,
      tiles ?? Map.from(this.tiles),
      spawns ?? List.from(this.spawns),
      score ?? this.score,
      movesLeft ?? this.movesLeft,
    );
  }

  final Level level;
  final Map<Key, Tile> tiles;
  final List<List<Tile>> spawns;
  final int score;
  final int movesLeft;
}

extension GameHelper on Game {
  Map<Key, Tile> getAllTiles() {
    Iterable<MapEntry<Key, Tile>> spawnMap = [];

    if (spawns.isNotEmpty) {
      spawnMap = spawns.expand((e) => e).map((e) => e.toMapEntry());
    }
    return Map.from(tiles)..addEntries(spawnMap);
  }
}

extension TileSpawners on Game {
  triggerSpawnEffect() {
    for (var coordinate in level.getSpawnerCoordinates()) {
      spawns.add(_spawnTilesAt(coordinate));
    }
  }

  triggerSpawnFallAnimation() {
    for (var spawnColumn in spawns) {
      for (var spawn in spawnColumn) {
        var offset = fallAnimations.offset * spawnColumn.length.toDouble();
        var fall = Translation(offset, fallAnimations.duration);
        tiles[spawn.key] = spawn.clone(container: spawn.container.translate(fall));
      }
    }
    spawns.clear();
  }

  List<Tile> _spawnTilesAt(Point<int> spawnerCoordinate) {
    List<Tile> column = [];
    while (_canSpawnTileAt(spawnerCoordinate + Point(0, column.length))) {
      var coordinate = spawnerCoordinate - Point(0, column.length + 1);
      column.add(Tile.spawnAt(coordinate, matchables: level.matchables));
    }
    return column;
  }

  _canSpawnTileAt(Point<int> coordinate) {
    var collision = dimensions.tileContainer(coordinate).center;
    try {
      if (coordinate.y > dimensions.rows) {
        throw ErrorDescription('Error cannot spawn below the grid');
      }
      if (level.tileMap[coordinate.y][coordinate.x].isIndestructibleObstacle()) {
        throw ErrorDescription('Error tile cannot spawn on indestructible obstacle');
      }
      for (var tile in tiles.values) {
        if (tile.container.box.contains(collision)) {
          throw ErrorDescription('Error tile cannot spawn on other tile');
        }
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}

extension TileSwapper on Game {
  Tile getTileByOffset(Offset offset) {
    return tiles.values.firstWhere((element) => element.container.box.contains(offset));
  }

  Tile getSideTileByDelta(Tile tile, Offset delta) {
    Offset offset = tile.container.sideCollisionFromDelta(delta);
    return getTileByOffset(offset);
  }

  bool canSwapTiles(Tile from, Tile to) {
    swapTiles(from, to, Duration.zero);
    bool containMatch = tiles.containMatch();
    print('containMatch $containMatch');
    revertSwap(from, to);
    return containMatch;
  }

  swapTiles(Tile from, Tile to, Duration duration, {double translatePercent = 1, bool revert = false}) {
    var swapFrom = Translation(
      (to.container.box.topLeft - from.container.box.topLeft) * translatePercent,
      duration,
      revert: revert,
    );
    var swapTo = Translation(
      (from.container.box.topLeft - to.container.box.topLeft) * translatePercent,
      duration,
      revert: revert,
    );
    tiles[from.key] = from.clone(container: from.container.translate(swapFrom));
    tiles[to.key] = to.clone(container: to.container.translate(swapTo));
  }

  revertSwap(Tile from, Tile to) {
    tiles[from.key] = from.clone(container: Transformable.fromRect(from.container.box));
    tiles[to.key] = to.clone(container: Transformable.fromRect(to.container.box));
  }

  fakeSwapToShowFailure(Tile from, Tile to, Duration duration) {
    swapTiles(from, to, duration, translatePercent: 0.4, revert: true);
  }

  flattenTiles(Tile from, Tile to) {
    tiles[from.key] = from.clone(container: from.container.flatten());
    tiles[to.key] = to.clone(container: to.container.flatten());
  }
}
