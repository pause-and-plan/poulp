import 'package:flutter/material.dart';
import 'package:poulp/models/matching_group.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/tiles.dart';

class MatchingGroups {
  MatchingGroups(this.tiles) {
    _extractGroups();
  }

  Map<Key, Tile> tiles;
  Map<Key, MatchingGroup> groups = {};
  Map<Key, Set<Key>> membersToGroup = {};

  _add(MatchingGroup group) {
    groups[group.key] = group;
    for (var member in group.members) {
      membersToGroup[member] = Set<Key>.from(membersToGroup[member] ?? {})..add(group.key);
    }
  }

  _addAll(Iterable<MatchingGroup> all) {
    for (var group in all) {
      _add(group);
    }
  }

  MatchingGroup? _removeGroup(Key groupKey) {
    var group = groups[groupKey];
    if (group == null) throw ErrorDescription('MatchingGroups._removeGroup - group not found');
    for (var member in group.members) {
      if (membersToGroup[member] == null) throw ErrorDescription('MatchingGroups._removeGroup - member not found');
      membersToGroup[member] = membersToGroup[member]!..remove(groupKey);
    }
    return groups.remove(groupKey);
  }
}

extension GroupsExtractor on MatchingGroups {
  _extractGroups() {
    var rows = tiles.extractHorizontalGroups();
    var columns = tiles.extractVerticalGroups();
    print('rows ${rows.length}');
    print('columns ${columns.length}');

    _addAll([...rows, ...columns]);
    _crossMatchGroups();

    // debug
    print('groups ${groups.length}');
    groups.values.forEach((group) {
      group.debug(tiles: tiles);
    });
  }

  _crossMatchGroups() {
    List<MatchingGroup> crossMatchs = [];
    var linearGroups = groups.keys.toSet();
    while (linearGroups.isNotEmpty) {
      var matchs = _crossMatchGroup({linearGroups.first});
      var aggregation = matchs.reduce((accumulator, nextItem) {
        var result = MatchingGroup.crossMatch(accumulator, nextItem);
        if (result == null) throw ErrorDescription('_crossMatchGroups - Unexpected cross match failure');
        return result;
      });
      crossMatchs.add(aggregation);
      linearGroups.removeAll(matchs.map((e) => e.key));
    }
    _addAll(crossMatchs);
  }

  List<MatchingGroup> _crossMatchGroup(Set<Key> matchingGroups) {
    var group = _removeGroup(matchingGroups.last);
    if (group == null) throw ErrorDescription('_crossMatchGroups - group not found');

    List<MatchingGroup> matchs = [group];

    for (var memberKey in group.members) {
      var memberGroups = membersToGroup[memberKey];
      if (memberGroups == null) throw ErrorDescription('_crossMatchGroups - member not found');

      var diffs = memberGroups.difference(matchingGroups);
      for (var diff in diffs) {
        matchs.addAll(_crossMatchGroup(matchingGroups..add(diff)));
      }
    }
    return matchs;
  }
}
