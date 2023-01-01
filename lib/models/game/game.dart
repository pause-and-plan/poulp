import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poulp/models/grid/grid.dart';
import 'package:poulp/models/grid/transformation.dart';
import 'package:poulp/models/matching_group.dart';
import 'package:poulp/models/matching_groups.dart';
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
    var grid = Grid.empty();
    return Game(level, TilesGenerator.initFromLevel(level, grid), grid, 0, level.movesLeft);
  }

  const Game(this.level, this.tiles, this.grid, this.score, this.movesLeft);

  Game clone({Level? level, Map<Key, Tile>? tiles, Grid? grid, List<List<Tile>>? spawns, int? score, int? movesLeft}) {
    return Game(
      level ?? this.level,
      tiles ?? Map.from(this.tiles),
      grid ?? this.grid,
      score ?? this.score,
      movesLeft ?? this.movesLeft,
    );
  }

  final Level level;
  final Grid grid;
  final Map<Key, Tile> tiles;
  final int score;
  final int movesLeft;
}

extension GameHelper on Game {}

extension TilesTransformer on Game {
  translateTo(Key key) {}
}

extension TileSpawners on Game {
  // triggerSpawnFallAnimation(List<List<Key>> spawns) {
  //   for (var spawnColumn in spawns) {
  //     for (var key in spawnColumn) {
  //       var spawn = tiles[key];
  //       if (spawn == null) throw ErrorDescription('triggerSpawnFallAnimation tile key not found');
  //       var offset = fallAnimations.offset * spawnColumn.length.toDouble();
  //       var fall = Translation(offset, fallAnimations.duration * spawnColumn.length);
  //       tiles[key] = spawn.clone(container: spawn.container.translate(fall));
  //     }
  //   }
  // }

  // List<List<Key>> spawnTiles() {
  //   List<List<Key>> spawns = [];
  //   for (var coordinate in level.getSpawnerCoordinates()) {
  //     var column = _spawnTilesAt(coordinate);
  //     spawns.add(column);
  //   }
  //   return spawns;
  // }

  // List<Key> _spawnTilesAt(Point<int> spawnerCoordinate) {
  //   List<Key> column = [];
  //   while (_canSpawnTileAt(spawnerCoordinate + Point(0, column.length))) {
  //     var coordinate = spawnerCoordinate - Point(0, column.length + 1);
  //     var tile = Tile.spawnAt(coordinate, matchables: level.matchables);
  //     tiles[tile.key] = tile;
  //     column.add(tile.key);
  //   }
  //   return column;
  // }

  // _canSpawnTileAt(Point<int> coordinate) {
  //   var collision = dimensions.tileContainer(coordinate).center;
  //   try {
  //     if (coordinate.y > dimensions.rows) {
  //       throw ErrorDescription('Error cannot spawn below the grid');
  //     }
  //     if (level.tileMap[coordinate.y][coordinate.x].isIndestructibleObstacle()) {
  //       throw ErrorDescription('Error tile cannot spawn on indestructible obstacle');
  //     }
  //     for (var tile in tiles.values) {
  //       if (tile.container.contains(collision)) {
  //         throw ErrorDescription('Error tile cannot spawn on other tile');
  //       }
  //     }
  //     return true;
  //   } catch (error) {
  //     return false;
  //   }
  // }
}

extension TileSwapper on Game {
//   Tile getTileByOffset(Offset offset) {
//     return tiles.values.firstWhere((element) => element.container.contains(offset));
//   }

//   Tile getSideTileByDelta(Tile tile, Offset delta) {
//     Offset offset = tile.container.sideCollisionFromDelta(delta);
//     return getTileByOffset(offset);
//   }

//   bool canSwapTiles(Tile from, Tile to) {
//     swapTiles(from, to, Duration.zero);
//     bool containMatch = tiles.containMatch();
//     revertSwap(from, to);
//     return containMatch;
//   }

//   swapTiles(Tile from, Tile to, Duration duration, {double translatePercent = 1, bool revert = false}) {
//     var swapFrom = Translation(
//       (to.container.box.topLeft - from.container.box.topLeft) * translatePercent,
//       duration,
//       revert: revert,
//     );
//     var swapTo = Translation(
//       (from.container.box.topLeft - to.container.box.topLeft) * translatePercent,
//       duration,
//       revert: revert,
//     );
//     tiles[from.key] = from.clone(container: from.container.translate(swapFrom));
//     tiles[to.key] = to.clone(container: to.container.translate(swapTo));
//   }

//   revertSwap(Tile from, Tile to) {
//     tiles[from.key] = from.clone(container: Transformable.fromRect(from.container.box));
//     tiles[to.key] = to.clone(container: Transformable.fromRect(to.container.box));
//   }

//   fakeSwapToShowFailure(Tile from, Tile to, Duration duration) {
//     swapTiles(from, to, duration, translatePercent: 0.4, revert: true);
//   }

//   flattenTiles(Key from, Key to) {
//     tiles[from] = tiles[from]!.clone(container: tiles[from]!.container.flatten());
//     tiles[to] = tiles[to]!.clone(container: tiles[to]!.container.flatten());
//   }
}

extension TilesExploder on Game {
  // triggerExplodingAnimation(Map<Key, Tile> toExplode) {
  //   toExplode.forEach((key, tile) {
  //     var scaling = Scale(explodeAnimations.scale, explodeAnimations.duration);
  //     toExplode[key] = tile.clone(container: tile.container.scale(scaling));
  //   });
  // }

  // Map<Key, Tile> explodeTiles() {
  //   Map<Key, Tile> toAnimate = {};
  //   var groups = MatchingGroups(tiles).groups;

  //   groups.forEach((key, group) {
  //     toAnimate.addEntries(_explodeGroup(group));
  //   });
  //   print('explodeTiles ${toAnimate.length}');
  //   return toAnimate;
  // }

  // List<MapEntry<Key, Tile>> _explodeGroup(MatchingGroup group) {
  //   List<MapEntry<Key, Tile>> toExplode = [];
  //   var special = group.getSpecial(tiles);
  //   var explodingMembers = group.members;

  //   if (special != null) {
  //     tiles[special.key] = special;
  //     explodingMembers.remove(special.key);
  //   }
  //   toExplode.addAll(explodingMembers.map(_explodeTile));
  //   return toExplode;
  // }

  // MapEntry<Key, Tile> _explodeTile(Key key) {
  //   var tile = tiles.remove(key);
  //   if (tile == null) throw ErrorDescription('_explodeTile tile key not found');
  //   return MapEntry(key, tile);
  // }
}

// extension Gravity on Game {
//   Duration triggerFallingAnimation(Map<Key, Tile> toRemove) {
//     Duration fallMaxDuration = Duration.zero;
//     List<Key> tilesAbove = [];
//     toRemove.forEach((key, tile) {
//       tilesAbove.addAll(tiles.above(tile.container.translatedBox.center));
//     });

//     for (Key key in tilesAbove) {
//       var fallDuration = _makeTileFall(key);
//       if (fallMaxDuration.inMilliseconds < fallDuration.inMilliseconds) {
//         fallMaxDuration = fallDuration;
//       }
//     }
//     return fallMaxDuration;
//   }

//   Duration _makeTileFall(Key key) {
//     var fallingTile = tiles[key];
//     if (fallingTile == null) throw ErrorDescription('_makeTileFall tile key not found');
//     var fall = fallingTile.container.translation + Translation(fallAnimations.offset, fallAnimations.duration);
//     tiles[key] = fallingTile.clone(container: fallingTile.container.translate(fall));
//     return fall.duration;
//   }
// }
