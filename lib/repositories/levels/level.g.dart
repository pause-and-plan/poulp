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
          .map((e) => $enumDecode(_$TilesEnumMap, e))
          .toList())
      .toList();

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'version': instance.version,
      'mode': _$GameModeEnumMap[instance.mode]!,
      'scoreTargets': instance.scoreTargets,
      'randomSeed': instance.randomSeed,
      'tileMap': instance.tileMap
          .map((e) => e.map((e) => _$TilesEnumMap[e]!).toList())
          .toList(),
    };

const _$GameModeEnumMap = {
  GameMode.score: 'score',
  GameMode.blocker: 'blocker',
  GameMode.jelly: 'jelly',
  GameMode.item: 'item',
};

const _$TilesEnumMap = {
  Tiles.emptySpace: '001',
  Tiles.emptyTile: '002',
  Tiles.matchable: '003',
  Tiles.matchableSpawner: '004',
  Tiles.matchableHorizontal: '005',
  Tiles.matchableVertical: '006',
  Tiles.matchableWrapped: '007',
  Tiles.blockerLevel1: '008',
  Tiles.blockerLevel2: '009',
  Tiles.blockerLevel3: '010',
  Tiles.wrapperLevel1: '011',
  Tiles.wrapperLevel2: '012',
  Tiles.wrapperLevel3: '013',
  Tiles.item: '014',
};
