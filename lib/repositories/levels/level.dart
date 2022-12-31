import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:poulp/singletons/dimensions.dart';

part 'level.g.dart';

enum GameMode { score, blocker, wrapper, collectible }

enum Matchables { purple, blue, green, yellow, orange, red }

enum TileCodes {
  @JsonValue('001')
  emptySpace,
  @JsonValue('002')
  emptyTile,
  @JsonValue('003')
  matchable,
  @JsonValue('004')
  matchablePurple,
  @JsonValue('005')
  matchableBlue,
  @JsonValue('006')
  matchableGreen,
  @JsonValue('007')
  matchableYellow,
  @JsonValue('008')
  matchableOrange,
  @JsonValue('009')
  matchableRed,
  @JsonValue('010')
  matchableSpawner,
  @JsonValue('011')
  matchableHorizontal,
  @JsonValue('012')
  matchableVertical,
  @JsonValue('013')
  matchableBomb,
  @JsonValue('014')
  blockerLevel1,
  @JsonValue('015')
  blockerLevel2,
  @JsonValue('016')
  blockerLevel3,
  @JsonValue('017')
  wrapperLevel1,
  @JsonValue('018')
  wrapperLevel2,
  @JsonValue('019')
  wrapperLevel3,
  @JsonValue('020')
  collectible,
}

extension TileCodesUtils on TileCodes {
  bool isMatchable() {
    switch (this) {
      case TileCodes.matchable:
      case TileCodes.matchablePurple:
      case TileCodes.matchableBlue:
      case TileCodes.matchableGreen:
      case TileCodes.matchableYellow:
      case TileCodes.matchableOrange:
      case TileCodes.matchableRed:
      case TileCodes.matchableSpawner:
      case TileCodes.matchableHorizontal:
      case TileCodes.matchableVertical:
      case TileCodes.matchableBomb:
      case TileCodes.wrapperLevel1:
      case TileCodes.wrapperLevel2:
      case TileCodes.wrapperLevel3:
        return true;
      default:
        return false;
    }
  }

  bool isDefinedMatchable() {
    switch (this) {
      case TileCodes.matchablePurple:
      case TileCodes.matchableBlue:
      case TileCodes.matchableGreen:
      case TileCodes.matchableYellow:
      case TileCodes.matchableOrange:
      case TileCodes.matchableRed:
        return true;
      default:
        return false;
    }
  }

  bool isIndestructibleObstacle() {
    switch (this) {
      case TileCodes.emptySpace:
        return true;
      default:
        return false;
    }
  }
}

@JsonSerializable()
class Level {
  double version = 0.01;
  GameMode mode = GameMode.score;
  List<int> scoreTargets = [100, 200, 300];
  int movesLeft = 30;
  List<Matchables> matchables = Matchables.values;
  int randomSeed = 0;
  List<List<TileCodes>> tileMap = [
    [TileCodes.emptySpace]
  ];

  Level();

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelToJson(this);
}

extension LevelSpawners on Level {
  List<Point<int>> getSpawnerCoordinates() {
    List<Point<int>> coordinates = [];
    for (var y = 0; y < dimensions.cols; y++) {
      for (var x = 0; x < dimensions.cols; x++) {
        if (tileMap[y][x] == TileCodes.matchableSpawner) {
          coordinates.add(Point(x, y));
        }
      }
    }
    return coordinates;
  }
}
