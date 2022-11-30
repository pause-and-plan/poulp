import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

enum GameMode {
  score,
  blocker,
  jelly,
  item,
}

enum TileCodes {
  @JsonValue('001')
  emptySpace,
  @JsonValue('002')
  emptyTile,
  @JsonValue('003')
  matchable,
  @JsonValue('004')
  matchableSpawner,
  @JsonValue('005')
  matchableHorizontal,
  @JsonValue('006')
  matchableVertical,
  @JsonValue('007')
  matchableBomb,
  @JsonValue('008')
  blockerLevel1,
  @JsonValue('009')
  blockerLevel2,
  @JsonValue('010')
  blockerLevel3,
  @JsonValue('011')
  wrapperLevel1,
  @JsonValue('012')
  wrapperLevel2,
  @JsonValue('013')
  wrapperLevel3,
  @JsonValue('014')
  collectible,
}

const Size boardDimensions = Size(9, 9);

@JsonSerializable()
class Level {
  double version = 0.01;
  GameMode mode = GameMode.score;
  List<int> scoreTargets = [100, 200, 300];
  int randomSeed = 0;
  List<List<TileCodes>> tileMap = [
    [TileCodes.emptySpace]
  ];

  Level();

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelToJson(this);
}
