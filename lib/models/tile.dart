import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/repositories/levels/level.dart';

class Tile extends Equatable {
  static Tile spawn({
    List<Matchables>? matchables,
    SpecialMatchables? special,
    Blocker? blocker,
    Collectible? collectible,
  }) {
    Matchable? matchable;
    if (matchables != null && matchables.isNotEmpty) {
      matchable = Matchable.random(from: matchables, special: special);
    }
    return Tile(UniqueKey(), matchable, blocker, collectible);
  }

  const Tile(this.key, this.matchable, this.blocker, this.collectible);

  Tile clone({Matchable? matchable, Blocker? blocker, Collectible? collectible}) {
    return Tile(
      key,
      matchable ?? this.matchable,
      blocker ?? this.blocker,
      collectible ?? this.collectible,
    );
  }

  // identifiers
  final Key key;

  // content
  final Matchable? matchable;
  final Blocker? blocker;
  final Collectible? collectible;

  @override
  List<Object?> get props => [matchable, blocker, collectible];
}

extension TileHelper on Tile {
  Gradient? get gradient => matchable?.gradient() ?? blocker?.gradient();

  MapEntry<Key, Tile> toMapEntry() => MapEntry(key, this);
}

extension TileDebugger on Tile {
  debug() {
    print('>---');
    if (matchable != null) print('tile match: ${matchable?.match.name}');
    if (blocker != null) print('tile blocker: ${blocker?.type.name}');
    if (collectible != null) print('tile collectible: ${collectible?.type.name}');
  }
}
