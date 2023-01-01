import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/grid/grid.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/matching_group.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/singletons/dimensions.dart';

extension TilesHelper on Map<Key, Tile> {
  // List<Key> above(Offset offset) {
  //   return keys.where((key) => this[key]!.container.isAbove(offset)).toList();
  // }

  // flatten() {
  //   for (var tile in values) {
  //     this[tile.key] = tile.clone(container: tile.container.flatten());
  //   }
  // }
}

extension TilesGenerator on Map<Key, Tile> {
  static Map<Key, Tile> initFromLevel(Level level, Grid grid) {
    Map<Key, Tile> map = {};
    map._addTileRecursively(level, grid, const Point(0, 0));
    return map;
  }

  _addTileRecursively(Level level, Grid grid, Point<int>? point) {
    if (point == null) {
      return true;
    }
    var code = level.tileMap[point.y][point.x];
    var options = [...level.matchables];

    if (code == TileCodes.emptyTile) {
      return _addTileRecursively(level, grid, Grid.getNextCoordinates(point));
    }

    if (!code.isMatchable()) {
      Tile tile = _codeToTile(code, options);
      this[tile.key] = tile;
      grid.updateTile(tile.key, point);
      return _addTileRecursively(level, grid, Grid.getNextCoordinates(point));
    }

    if (code.isDefinedMatchable()) {
      Tile tile = _codeToTile(code, options);
      this[tile.key] = tile;
      grid.updateTile(tile.key, point);
      return _addTileRecursively(level, grid, Grid.getNextCoordinates(point));
    }

    while (options.isNotEmpty) {
      Tile tile = _codeToTile(code, options);
      options.remove(tile.matchable!.match);

      this[tile.key] = tile;
      grid.updateTile(tile.key, point);

      if (containMatch(grid)) {
        remove(tile.key);
        grid.removeTile(tile.key);
        continue;
      }

      var succeed = _addTileRecursively(level, grid, Grid.getNextCoordinates(point));
      if (succeed) return succeed;

      remove(tile.key);
      grid.removeTile(tile.key);
    }

    return false;
  }

  Tile _codeToTile(TileCodes code, List<Matchables> options) {
    switch (code) {
      case TileCodes.matchablePurple:
        return Tile.spawn(matchables: [Matchables.purple]);
      case TileCodes.matchableBlue:
        return Tile.spawn(matchables: [Matchables.blue]);
      case TileCodes.matchableGreen:
        return Tile.spawn(matchables: [Matchables.green]);
      case TileCodes.matchableYellow:
        return Tile.spawn(matchables: [Matchables.yellow]);
      case TileCodes.matchableOrange:
        return Tile.spawn(matchables: [Matchables.orange]);
      case TileCodes.matchableRed:
        return Tile.spawn(matchables: [Matchables.red]);
      case TileCodes.matchable:
      case TileCodes.matchableSpawner:
        return Tile.spawn(matchables: options);
      case TileCodes.matchableHorizontal:
        return Tile.spawn(matchables: options, special: SpecialMatchables.horizontal);
      case TileCodes.matchableVertical:
        return Tile.spawn(matchables: options, special: SpecialMatchables.vertical);
      case TileCodes.matchableBomb:
        return Tile.spawn(matchables: options, special: SpecialMatchables.bomb);
      case TileCodes.wrapperLevel1:
        return Tile.spawn(matchables: options, blocker: const Blocker(Blockers.wrapper, level: 0));
      case TileCodes.wrapperLevel2:
        return Tile.spawn(matchables: options, blocker: const Blocker(Blockers.wrapper, level: 1));
      case TileCodes.wrapperLevel3:
        return Tile.spawn(matchables: options, blocker: const Blocker(Blockers.wrapper, level: 2));
      case TileCodes.blockerLevel1:
        return Tile.spawn(blocker: const Blocker(Blockers.block, level: 0));
      case TileCodes.blockerLevel2:
        return Tile.spawn(blocker: const Blocker(Blockers.block, level: 1));
      case TileCodes.blockerLevel3:
        return Tile.spawn(blocker: const Blocker(Blockers.block, level: 2));
      case TileCodes.collectible:
        return Tile.spawn(collectible: const Collectible(Collectibles.cherry));
      default:
        throw ErrorDescription("Unhandled TilesCode detected $code");
    }
  }
}

extension GroupsExtractorHelper on Map<Key, Tile> {
  bool containMatch(Grid grid) {
    var rows = extractHorizontalGroups(grid);
    if (rows.isNotEmpty) return true;

    var columns = extractVerticalGroups(grid);
    if (columns.isNotEmpty) return true;

    return false;
  }

  List<MatchingGroup> extractHorizontalGroups(Grid grid) {
    List<MatchingGroup> result = [];
    List<Key> toSkip = [];
    for (var key in keys) {
      if (toSkip.contains(key)) continue;

      var members = getHorizontalMatchingTiles(grid, key);
      if (members != null) {
        result.add(MatchingGroup.horizontal(members));
        toSkip.addAll(members);
      }
    }
    return result;
  }

  List<MatchingGroup> extractVerticalGroups(Grid grid) {
    List<MatchingGroup> result = [];
    List<Key> toSkip = [];
    for (var key in keys) {
      if (toSkip.contains(key)) continue;

      var members = getVerticalMatchingTiles(grid, key);
      if (members != null) {
        result.add(MatchingGroup.vertical(members));
        toSkip.addAll(members);
      }
    }
    return result;
  }

  List<Key>? getVerticalMatchingTiles(Grid grid, Key key) {
    List<Key> list = [key];
    var match = _tileMatch(key);

    if (match == null) {
      return list;
    }

    Key? top = grid.getTopTile(key);
    Key? bottom = grid.getBottomTile(key);

    while (top != null) {
      if (match != _tileMatch(top)) break;
      list.add(top);
      top = grid.getTopTile(top);
    }

    while (bottom != null) {
      if (match != _tileMatch(bottom)) break;
      list.add(bottom);
      bottom = grid.getBottomTile(bottom);
    }

    if (list.length >= 3) return list;
    return null;
  }

  List<Key>? getHorizontalMatchingTiles(Grid grid, Key key) {
    List<Key> list = [key];
    var match = _tileMatch(key);

    if (match == null) {
      return list;
    }

    Key? left = grid.getLeftTile(key);
    Key? right = grid.getRightTile(key);

    while (left != null) {
      if (match != _tileMatch(left)) break;
      list.add(left);
      left = grid.getLeftTile(left);
    }

    while (right != null) {
      if (match != _tileMatch(right)) break;
      list.add(right);
      right = grid.getRightTile(right);
    }

    if (list.length >= 3) return list;
    return null;
  }

  Matchables? _tileMatch(Key key) => this[key]?.matchable?.match;
}

extension TilesDebugger on Map<Key, Tile> {
  debug() {
    print('Tiles amount $length');
    for (Tile tile in values) {
      tile.debug();
    }
  }
}
