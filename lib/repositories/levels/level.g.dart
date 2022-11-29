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
      'randomSeed': instance.randomSeed,
      'tileMap': instance.tileMap
          .map((e) => e.map((e) => _$TileCodesEnumMap[e]!).toList())
          .toList(),
    };

const _$GameModeEnumMap = {
  GameMode.score: 'score',
  GameMode.blocker: 'blocker',
  GameMode.jelly: 'jelly',
  GameMode.item: 'item',
};

const _$TileCodesEnumMap = {
  TileCodes.emptySpace: '001',
  TileCodes.emptyTile: '002',
  TileCodes.matchable: '003',
  TileCodes.matchableSpawner: '004',
  TileCodes.matchableHorizontal: '005',
  TileCodes.matchableVertical: '006',
  TileCodes.matchableWrapped: '007',
  TileCodes.blockerLevel1: '008',
  TileCodes.blockerLevel2: '009',
  TileCodes.blockerLevel3: '010',
  TileCodes.wrapperLevel1: '011',
  TileCodes.wrapperLevel2: '012',
  TileCodes.wrapperLevel3: '013',
  TileCodes.item: '014',
};
