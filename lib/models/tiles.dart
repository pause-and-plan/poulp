import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/matching_group.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/singletons/dimensions.dart';

extension TilesHelper on Map<Key, Tile> {
  List<Key> above(Offset offset) {
    return keys.where((key) => this[key]!.container.isAbove(offset)).toList();
  }

  flatten() {
    for (var tile in values) {
      this[tile.key] = tile.clone(container: tile.container.flatten());
    }
  }
}

extension TilesGenerator on Map<Key, Tile> {
  static Map<Key, Tile> initFromLevel(Level level) {
    Map<Key, Tile> map = {};
    map._addTileRecursively(level, 0);
    return map;
  }

  _addTileRecursively(Level level, int index) {
    if (index >= dimensions.cols * dimensions.rows) {
      return true;
    }
    var y = _yFromIndex(index);
    var x = _xFromIndex(index);
    var code = _codeFromYX(level, y, x);
    var options = [...level.matchables];

    if (!code.isMatchable()) {
      Tile tile = _codeToTile(level, Point(x, y), options);
      this[tile.key] = tile;
      return _addTileRecursively(level, index + 1);
    }

    while (options.isNotEmpty) {
      Tile tile = _codeToTile(level, Point(x, y), options);
      options.remove(tile.matchable!.match);

      this[tile.key] = tile;

      if (containMatch()) {
        remove(tile.key);
        continue;
      }

      var succeed = _addTileRecursively(level, index + 1);
      if (succeed) return succeed;

      remove(tile.key);
    }

    return false;
  }

  int _xFromIndex(int index) => index % dimensions.cols;
  int _yFromIndex(int index) => (index / dimensions.cols).floor();
  TileCodes _codeFromYX(Level level, int y, int x) => level.tileMap[y][x];

  Tile _codeToTile(Level level, Point<int> coordinate, List<Matchables> options) {
    switch (level.tileMap[coordinate.y][coordinate.x]) {
      case TileCodes.matchable:
      case TileCodes.matchableSpawner:
        return Tile.spawnAt(coordinate, matchables: options);
      case TileCodes.matchableHorizontal:
        return Tile.spawnAt(coordinate, matchables: options, special: SpecialMatchables.horizontal);
      case TileCodes.matchableVertical:
        return Tile.spawnAt(coordinate, matchables: options, special: SpecialMatchables.vertical);
      case TileCodes.matchableBomb:
        return Tile.spawnAt(coordinate, matchables: options, special: SpecialMatchables.bomb);
      case TileCodes.wrapperLevel1:
        return Tile.spawnAt(coordinate, matchables: options, blocker: const Blocker(Blockers.wrapper, level: 0));
      case TileCodes.wrapperLevel2:
        return Tile.spawnAt(coordinate, matchables: options, blocker: const Blocker(Blockers.wrapper, level: 1));
      case TileCodes.wrapperLevel3:
        return Tile.spawnAt(coordinate, matchables: options, blocker: const Blocker(Blockers.wrapper, level: 2));
      case TileCodes.blockerLevel1:
        return Tile.spawnAt(coordinate, blocker: const Blocker(Blockers.block, level: 0));
      case TileCodes.blockerLevel2:
        return Tile.spawnAt(coordinate, blocker: const Blocker(Blockers.block, level: 1));
      case TileCodes.blockerLevel3:
        return Tile.spawnAt(coordinate, blocker: const Blocker(Blockers.block, level: 2));
      case TileCodes.collectible:
        return Tile.spawnAt(coordinate, collectible: const Collectible(Collectibles.cherry));
      default:
        throw ErrorDescription("Unhandled TilesCode detected ${level.tileMap[coordinate.y][coordinate.x]}");
    }
  }
}

extension GroupsExtractorHelper on Map<Key, Tile> {
  bool containMatch() {
    var rows = extractHorizontalGroups();
    if (rows.isNotEmpty) return true;

    var columns = extractVerticalGroups();
    if (columns.isNotEmpty) return true;

    return false;
  }

  List<MatchingGroup> extractHorizontalGroups() {
    List<MatchingGroup> result = [];
    List<Key> toSkip = [];
    for (var key in keys) {
      if (toSkip.contains(key)) continue;

      var members = getHorizontalMatchingTiles(key);
      if (members != null) {
        result.add(MatchingGroup.horizontal(members));
        toSkip.addAll(members);
      }
    }
    return result;
  }

  List<MatchingGroup> extractVerticalGroups() {
    List<MatchingGroup> result = [];
    List<Key> toSkip = [];
    for (var key in keys) {
      if (toSkip.contains(key)) continue;

      var members = getVerticalMatchingTiles(key);
      if (members != null) {
        result.add(MatchingGroup.vertical(members));
        toSkip.addAll(members);
      }
    }
    return result;
  }

  List<Key>? getVerticalMatchingTiles(Key key) {
    List<Key> list = [key];
    var match = _tileMatch(key);

    if (match == null) {
      return list;
    }

    Key? top = topTile(key);
    Key? bottom = _bottomTile(key);

    while (top != null) {
      if (match != _tileMatch(top)) break;
      list.add(top);
      top = topTile(top);
    }

    while (bottom != null) {
      if (match != _tileMatch(bottom)) break;
      list.add(bottom);
      bottom = _bottomTile(bottom);
    }

    if (list.length >= 3) return list;
    return null;
  }

  List<Key>? getHorizontalMatchingTiles(Key key) {
    List<Key> list = [key];
    var match = _tileMatch(key);

    if (match == null) {
      return list;
    }

    Key? left = _leftTile(key);
    Key? right = _rightTile(key);

    while (left != null) {
      if (match != _tileMatch(left)) break;
      list.add(left);
      left = _leftTile(left);
    }

    while (right != null) {
      if (match != _tileMatch(right)) break;
      list.add(right);
      right = _rightTile(right);
    }

    if (list.length >= 3) return list;
    return null;
  }

  Key? topTile(Key key) => getTileByOffset(_tileContainer(key)?.topCollision);
  Key? _bottomTile(Key key) => getTileByOffset(_tileContainer(key)?.bottomCollision);
  Key? _leftTile(Key key) => getTileByOffset(_tileContainer(key)?.leftCollision);
  Key? _rightTile(Key key) => getTileByOffset(_tileContainer(key)?.rightCollision);
  Key? getTileByOffset(Offset? collision) {
    try {
      if (collision == null) throw ErrorDescription('Invalid argument');
      return values.firstWhere((e) => e.container.contains(collision)).key;
    } catch (_) {
      return null;
    }
  }

  Matchables? _tileMatch(Key key) => this[key]?.matchable?.match;
  Transformable? _tileContainer(Key key) => this[key]?.container;
}

extension TilesDebugger on Map<Key, Tile> {
  debug() {
    print('Tiles amount $length');
    for (Tile tile in values) {
      tile.debug();
    }
  }
}
