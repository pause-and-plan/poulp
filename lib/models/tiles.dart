import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/repositories/levels/level.dart';

extension TilesGenerator on List<Tile> {
  initFromLevel(Level level) {
    _addTileRecursively(level, 0);
  }

  _addTileRecursively(Level level, int index) {
    if (index >= boardDimensions.width * boardDimensions.height) {
      return true;
    }
    var y = _yFromIndex(index);
    var x = _xFromIndex(index);
    var code = _codeFromYX(level, y, x);
    var options = [...level.matchables];

    if (!code.isMatchable()) {
      Tile? tile = _codeToTile(level, code, options)?..setPositionFromYX(y, x);
      if (tile != null) add(tile);
      return _addTileRecursively(level, index + 1);
    }

    while (options.isNotEmpty) {
      Tile tile = _codeToTile(level, code, options)!..setPositionFromYX(y, x);
      options.remove(tile.matchable!.match);

      add(tile);

      if (containMatch()) {
        remove(tile);
        continue;
      }

      var succeed = _addTileRecursively(level, index + 1);
      if (succeed) return succeed;

      remove(tile);
    }

    return false;
  }

  int _xFromIndex(int index) => index % boardDimensions.width.toInt();
  int _yFromIndex(int index) => (index / boardDimensions.width).floor();
  TileCodes _codeFromYX(Level level, int y, int x) => level.tileMap[y][x];

  Tile? _codeToTile(Level level, TileCodes code, List<Matchables> options) {
    Tile tile = Tile();

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

extension TilesMatcher on List<Tile> {
  bool containMatch() => getMatchingTilesKey().isNotEmpty;

  List<Key> getMatchingTilesKey() {
    var keys = List<Key>.empty(growable: true);
    for (var index = 0; index < length; index++) {
      // var vertical = _getVerticalMatchingTiles(index);
      var horizontal = _getHorizontalMatchingTiles(index);
      // if (vertical.length >= 2) keys.addAll(vertical);
      if (horizontal.length >= 2) keys.addAll(horizontal);
    }
    var list = keys.toSet().toList();
    // print('keys $list ${list.map(
    //   (e) => firstWhere((element) => element.key == e).matchable!.match.name,
    // )}');
    return list;
  }

  List<Key> _getVerticalMatchingTiles(int index) {
    var keys = List<Key>.empty(growable: true);
    var match = _tileMatch(index);

    if (match == null) {
      return keys;
    }

    int? top = _topTileIndex(index);
    int? bottom = _bottomTileIndex(index);

    while (top != null) {
      if (match != _tileMatch(top)) break;
      keys.add(_tileKey(top));
      top = _topTileIndex(top);
    }

    while (bottom != null) {
      if (match != _tileMatch(bottom)) break;
      keys.add(_tileKey(bottom));
      bottom = _bottomTileIndex(bottom);
    }
    return keys;
  }

  List<Key> _getHorizontalMatchingTiles(int index) {
    var keys = List<Key>.empty(growable: true);
    var match = _tileMatch(index);

    if (match == null) {
      return keys;
    }

    int? left = _leftTileIndex(index);
    int? right = _rightTileIndex(index);

    while (left != null) {
      if (match != _tileMatch(left)) break;
      keys.add(_tileKey(left));
      left = _leftTileIndex(left);
    }

    while (right != null) {
      if (match != _tileMatch(right)) break;
      keys.add(_tileKey(right));
      right = _rightTileIndex(right);
    }
    return keys;
  }

  int? _topTileIndex(index) {
    var container = _tileContainer(index);
    var topIndex = indexWhere((element) => element.container.isColliding(container.topCollision()));
    return topIndex != -1 ? topIndex : null;
  }

  int? _bottomTileIndex(index) {
    var container = _tileContainer(index);
    var bottomIndex = indexWhere((element) => element.container.isColliding(container.bottomCollision()));
    return bottomIndex != -1 ? bottomIndex : null;
  }

  int? _leftTileIndex(index) {
    var container = _tileContainer(index);
    var leftIndex = indexWhere((element) => element.container.isColliding(container.leftCollision()));
    return leftIndex != -1 ? leftIndex : null;
  }

  int? _rightTileIndex(index) {
    var container = _tileContainer(index);
    var rightIndex = indexWhere((element) => element.container.isColliding(container.rightCollision()));
    return rightIndex != -1 ? rightIndex : null;
  }

  Matchables? _tileMatch(int index) => this[index].matchable?.match;
  Transformable _tileContainer(int index) => this[index].container;
  Key _tileKey(int index) => this[index].key;
}

extension TilesDebugger on List<Tile> {
  debug() {
    print('Tiles amount $length');
    for (Tile tile in this) {
      tile.debug();
    }
  }
}
