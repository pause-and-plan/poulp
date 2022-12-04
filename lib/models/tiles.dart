import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/matching_group.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/singletons/animations.dart';
import 'package:poulp/singletons/dimensions.dart';

extension TilesHelper on Map<Key, Tile> {
  Map<Key, Tile> clone() => Map<Key, Tile>.fromEntries(entries.map((e) => MapEntry(e.key, e.value.clone())));
}

extension TilesGenerator on Map<Key, Tile> {
  initFromLevel(Level level) {
    _addTileRecursively(level, 0);
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
      Tile? tile = _codeToTile(level, code, options)?..setPositionFromYX(y, x);
      if (tile != null) this[tile.key] = tile;
      return _addTileRecursively(level, index + 1);
    }

    while (options.isNotEmpty) {
      Tile tile = _codeToTile(level, code, options)!..setPositionFromYX(y, x);
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

  Tile? _codeToTile(Level level, TileCodes code, List<Matchables> options) {
    Tile tile = Tile.empty();

    switch (code) {
      case TileCodes.matchable:
        tile.matchable = Matchable.random(from: options);
        break;
      case TileCodes.matchableHorizontal:
        tile.matchable = Matchable.random(from: options, special: SpecialMatchables.horizontal);
        break;
      case TileCodes.matchableVertical:
        tile.matchable = Matchable.random(from: options, special: SpecialMatchables.vertical);
        break;
      case TileCodes.matchableBomb:
        tile.matchable = Matchable.random(from: options, special: SpecialMatchables.bomb);
        break;
      case TileCodes.wrapperLevel1:
        tile.matchable = Matchable.random(from: options);
        tile.blocker = Blocker(Blockers.wrapper, level: 0);
        break;
      case TileCodes.wrapperLevel2:
        tile.matchable = Matchable.random(from: options);
        tile.blocker = Blocker(Blockers.wrapper, level: 1);
        break;
      case TileCodes.wrapperLevel3:
        tile.matchable = Matchable.random(from: options);
        tile.blocker = Blocker(Blockers.wrapper, level: 2);
        break;
      case TileCodes.blockerLevel1:
        tile.blocker = Blocker(Blockers.block, level: 0);
        break;
      case TileCodes.blockerLevel2:
        tile.blocker = Blocker(Blockers.block, level: 1);
        break;
      case TileCodes.blockerLevel3:
        tile.blocker = Blocker(Blockers.block, level: 2);
        break;
      case TileCodes.collectible:
        tile.collectible = Collectible(Collectibles.cherry);
        break;
      default:
        return null;
    }
    return tile;
  }
}

extension TilesMatcher on Map<Key, Tile> {
  bool containMatch() => getMatchingGroups().isNotEmpty;

  Map<Key, MatchingGroup> getMatchingGroups() {
    var allGroups = _getAllMatchingGroups();
    var filteredGroups = _filterMatchingGroups(allGroups);
    return filteredGroups;
  }

  applyMatchingGroups(Map<Key, MatchingGroup> groups) {
    groups.values.forEach(_applyMatchingGroup);
  }

  flatten() {
    for (var tile in values) {
      tile.container.flatten();
    }
  }

  Map<Key, MatchingGroup> _getAllMatchingGroups() {
    Map<Key, MatchingGroup> groups = {};
    for (var key in keys) {
      var group = MatchingGroup(key, _getVerticalMatchingTiles(key), _getHorizontalMatchingTiles(key));
      if (group.containMatch) {
        groups[group.key] = group;
      }
    }
    return groups;
  }

  Map<Key, MatchingGroup> _filterMatchingGroups(Map<Key, MatchingGroup> groups) {
    List<Key> checklist = List.from(groups.keys);

    while (checklist.isNotEmpty) {
      var group = groups[checklist.removeAt(0)];
      if (group == null) continue;
      var members = group.members;
      while (members.isNotEmpty) {
        var otherGroup = groups[members.removeAt(0)];
        if (otherGroup == null) continue;

        if (group.isMoreRelevantThanDoublon(this, otherGroup)) {
          groups.remove(otherGroup.key);
          checklist.remove(otherGroup.key);
        } else {
          groups.remove(group.key);
          break;
        }
      }
    }
    return groups;
  }

  _applyMatchingGroup(MatchingGroup group) {
    if (group.hasSpecialEffect) {
      _applySpecialGroupEffect(group);
    } else {
      _removeItem(group.key);
    }
    group.members.forEach(_removeItem);
  }

  _removeItem(Key key) {
    var top = _topTile(key);
    remove(key);

    while (top != null) {
      if (this[top]!.blocker != null) break;
      var container = this[top]!.container;
      top = _topTile(top);
      container.transform(translate: fallAnimations.offset, duration: fallAnimations.duration);
    }
  }

  _applySpecialGroupEffect(MatchingGroup group) {
    var matchable = this[group.key]?.matchable;
    if (matchable == null) return;

    matchable.special = group.getSpecial();
  }

  List<Key> _getVerticalMatchingTiles(Key key) {
    var list = List<Key>.empty(growable: true);
    var match = _tileMatch(key);

    if (match == null) {
      return list;
    }

    Key? top = _topTile(key);
    Key? bottom = _bottomTile(key);

    while (top != null) {
      if (match != _tileMatch(top)) break;
      list.add(top);
      top = _topTile(top);
    }

    while (bottom != null) {
      if (match != _tileMatch(bottom)) break;
      list.add(bottom);
      bottom = _bottomTile(bottom);
    }

    return list;
  }

  List<Key> _getHorizontalMatchingTiles(Key key) {
    var list = List<Key>.empty(growable: true);
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

    return list;
  }

  Key? _topTile(Key key) => _getTileByOffset(_tileContainer(key)?.topCollision());
  Key? _bottomTile(Key key) => _getTileByOffset(_tileContainer(key)?.bottomCollision());
  Key? _leftTile(Key key) => _getTileByOffset(_tileContainer(key)?.leftCollision());
  Key? _rightTile(Key key) => _getTileByOffset(_tileContainer(key)?.rightCollision());
  Key? _getTileByOffset(Offset? collision) {
    try {
      if (collision == null) throw ErrorDescription('Invalid argument');
      return values.firstWhere((element) => element.container.isColliding(collision)).key;
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
