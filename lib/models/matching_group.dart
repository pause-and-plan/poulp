import 'package:flutter/material.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/tile.dart';

extension MatchingGroupsHelper on Map<Key, MatchingGroup> {
  Map<Key, MatchingGroup> clone() =>
      Map<Key, MatchingGroup>.fromEntries(entries.map((e) => MapEntry(e.key, e.value.clone())));
}

class MatchingGroup {
  MatchingGroup(this.key, this.verticals, this.horizontals);
  Key key;
  List<Key> verticals;
  List<Key> horizontals;

  bool get isVertical => verticals.length >= 2;
  bool get isHorizontal => horizontals.length >= 2;
  bool get containMatch => isVertical || isHorizontal;
  List<Key> get members => [...(isVertical ? verticals : []), ...(isHorizontal ? horizontals : [])];
  List<Key> get all => [...members, key];

  bool get hasSpecialEffect => getSpecial() != null;
  SpecialMatchables? getSpecial() {
    if (verticals.length >= 2 && horizontals.length >= 2) {
      return SpecialMatchables.bomb;
    } else if (verticals.length >= 3) {
      return SpecialMatchables.vertical;
    } else if (horizontals.length >= 3) {
      return SpecialMatchables.horizontal;
    }
    return null;
  }

  MatchingGroup clone() => MatchingGroup(key, verticals, horizontals);

  isMoreRelevantThanDoublon(Map<Key, Tile> tiles, MatchingGroup otherGroup) {
    if (members.length > otherGroup.members.length) {
      return true;
    }
    if (tiles[key]!.container.createdAt.isAfter(tiles[otherGroup.key]!.container.createdAt)) {
      return true;
    }
    return false;
  }

  debug() {
    print('index $key members $members vertical $isVertical horizontal $isHorizontal');
  }
}
