import 'package:flutter/material.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/repositories/levels/level.dart';

enum MatchingGroupType {
  vertical,
  horizontal,
  cross,
}

extension MatchingGroupTypeHelper on MatchingGroupType {
  bool get isVertical => this == MatchingGroupType.vertical;
  bool get isHorizontal => this == MatchingGroupType.horizontal;
  bool get isCross => this == MatchingGroupType.cross;
  bool get isLinear => this != MatchingGroupType.cross;
  SpecialMatchables get specialMatchable {
    switch (this) {
      case MatchingGroupType.horizontal:
        return SpecialMatchables.horizontal;
      case MatchingGroupType.vertical:
        return SpecialMatchables.vertical;
      case MatchingGroupType.cross:
        return SpecialMatchables.bomb;
    }
  }
}

class MatchingGroup {
  MatchingGroup({required this.commons, required this.horizontals, required this.verticals});

  Key key = UniqueKey();
  Iterable<Key> commons;
  Iterable<Iterable<Key>> horizontals;
  Iterable<Iterable<Key>> verticals;

  Set<Key> get members => {...horizontals.expand((e) => e), ...verticals.expand((e) => e)};
  MatchingGroupType get type {
    if (horizontals.isNotEmpty && verticals.isNotEmpty) {
      return MatchingGroupType.cross;
    } else if (horizontals.isNotEmpty) {
      return MatchingGroupType.horizontal;
    } else if (verticals.isNotEmpty) {
      return MatchingGroupType.vertical;
    }
    throw ErrorDescription('MatchingGroup get type - unhandled case');
  }

  static MatchingGroup vertical(Iterable<Key> line) {
    return MatchingGroup(commons: [], horizontals: [], verticals: [line]);
  }

  static MatchingGroup horizontal(Iterable<Key> line) {
    return MatchingGroup(commons: [], horizontals: [line], verticals: []);
  }

  static MatchingGroup? crossMatch(MatchingGroup first, MatchingGroup second) {
    var all = [...first.members, ...second.members];
    var withoutDoublon = all.toSet().toList();
    if (withoutDoublon.length != all.length) {
      withoutDoublon.forEach(all.remove);

      if (all.isEmpty) {
        throw ErrorDescription('MatchingGroup.crossMatch - unexpected amount of cross match ${all.length}');
      }
      return MatchingGroup(
        commons: [...first.commons, ...second.commons, all.first],
        horizontals: [...first.horizontals, ...second.horizontals],
        verticals: [...first.verticals, ...second.verticals],
      );
    }
    return null;
  }
}

extension MatchingGroupHelper on MatchingGroup {
  Tile? getSpecial(Map<Key, Tile> tiles) {
    if (type.isLinear) return _getSpecialFromLinearGroup(tiles);
    return _getSpecialFromCrossGroup(tiles);
  }

  Tile? _getSpecialFromLinearGroup(Map<Key, Tile> tiles) {
    if (commons.isNotEmpty) throw ErrorDescription('_getSpecialFromLinearGroup - commons not empty');
    var key = _getMostRecentMember(members, tiles);
    var tile = tiles[key];
    if (tile == null) throw ErrorDescription('_getSpecialFromLinearGroup - key $key not found');
    if (members.length > 3) {
      return tile.clone(matchable: tile.matchable!.clone(special: type.specialMatchable));
    }
    return null;
  }

  Tile _getSpecialFromCrossGroup(Map<Key, Tile> tiles) {
    if (commons.isEmpty) throw ErrorDescription('_getSpecialFromCrossGroup - commons is empty');
    Map<Key, int> verticalsMatch = {};
    Map<Key, int> horizontalsMatch = {};

    for (var key in commons) {
      verticalsMatch[key] = 0;
      horizontalsMatch[key] = 0;
      for (var line in horizontals) {
        if (line.contains(key)) {
          horizontalsMatch[key] = horizontalsMatch[key]! + line.length;
        }
      }
      for (var line in verticals) {
        if (line.contains(key)) {
          verticalsMatch[key] = verticalsMatch[key]! + line.length;
        }
      }
    }

    var main = commons.reduce((biggestMatcher, otherMatcher) {
      var biggest = verticalsMatch[biggestMatcher]! + horizontalsMatch[biggestMatcher]!;
      var other = verticalsMatch[otherMatcher]! + horizontalsMatch[otherMatcher]!;
      if (biggest < other) {
        return otherMatcher;
      } else if (biggest == other) {
        return _getMostRecentMember([biggestMatcher, otherMatcher], tiles);
      } else {
        return biggestMatcher;
      }
    });

    var tile = tiles[main];
    if (tile == null) throw ErrorDescription('_getSpecialFromCrossGroup - main tile not found');
    return tile.clone(matchable: tile.matchable!.clone(special: type.specialMatchable));
  }

  static Key _getMostRecentMember(Iterable<Key> members, Map<Key, Tile> tiles) {
    var main = members.reduce((mostRecent, other) {
      var mostRecentDate = tiles[mostRecent]!.container.createdAt;
      var otherDate = tiles[other]!.container.createdAt;
      if (otherDate.isAfter(mostRecentDate)) return other;
      return mostRecent;
    });
    return main;
  }
}

extension MatchingGroupDebugger on MatchingGroup {
  debug({Map<Key, Tile>? tiles}) {
    Matchables? color;
    if (tiles != null) {
      var tile = tiles[members.first];
      if (tile != null) {
        color = tile.matchable!.match;
      }
    }
    print('group $key rows ${horizontals.length} columns ${verticals.length} color ${color.toString()}');
  }
}
