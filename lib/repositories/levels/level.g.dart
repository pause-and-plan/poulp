// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Level _$LevelFromJson(Map<String, dynamic> json) => Level()
  ..version = (json['version'] as num).toDouble()
  ..mode = $enumDecode(_$GameModeEnumMap, json['mode'])
  ..scoreTargets =
      (json['scoreTargets'] as List<dynamic>).map((e) => e as int).toList()
  ..movesLeft = json['movesLeft'] as int
  ..matchables = (json['matchables'] as List<dynamic>)
      .map((e) => $enumDecode(_$MatchablesEnumMap, e))
      .toList()
  ..randomSeed = json['randomSeed'] as int
  ..tileMap = (json['tileMap'] as List<dynamic>)
      .map((e) => (e as List<dynamic>)
          .map((e) => $enumDecode(_$TileCodesEnumMap, e))
          .toList())
      .toList();

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'version': instance.version,
      'mode': _$GameModeEnumMap[instance.mode]!,
      'scoreTargets': instance.scoreTargets,
      'movesLeft': instance.movesLeft,
      'matchables':
          instance.matchables.map((e) => _$MatchablesEnumMap[e]!).toList(),
      'randomSeed': instance.randomSeed,
      'tileMap': instance.tileMap
          .map((e) => e.map((e) => _$TileCodesEnumMap[e]!).toList())
          .toList(),
    };

const _$GameModeEnumMap = {
  GameMode.score: 'score',
  GameMode.blocker: 'blocker',
  GameMode.wrapper: 'wrapper',
  GameMode.collectible: 'collectible',
};

const _$MatchablesEnumMap = {
  Matchables.purple: 'purple',
  Matchables.blue: 'blue',
  Matchables.green: 'green',
  Matchables.yellow: 'yellow',
  Matchables.orange: 'orange',
  Matchables.red: 'red',
};

const _$TileCodesEnumMap = {
  TileCodes.emptySpace: '001',
  TileCodes.emptyTile: '002',
  TileCodes.matchable: '003',
  TileCodes.matchablePurple: '004',
  TileCodes.matchableBlue: '005',
  TileCodes.matchableGreen: '006',
  TileCodes.matchableYellow: '007',
  TileCodes.matchableOrange: '008',
  TileCodes.matchableRed: '009',
  TileCodes.matchableSpawner: '010',
  TileCodes.matchableHorizontal: '011',
  TileCodes.matchableVertical: '012',
  TileCodes.matchableBomb: '013',
  TileCodes.blockerLevel1: '014',
  TileCodes.blockerLevel2: '015',
  TileCodes.blockerLevel3: '016',
  TileCodes.wrapperLevel1: '017',
  TileCodes.wrapperLevel2: '018',
  TileCodes.wrapperLevel3: '019',
  TileCodes.collectible: '020',
};
