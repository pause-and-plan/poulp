import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/singletons/dimensions.dart';

class Tile extends Equatable {
  static Tile spawnAt(
    Point<int> coordinate, {
    List<Matchables>? matchables,
    SpecialMatchables? special,
    Blocker? blocker,
    Collectible? collectible,
  }) {
    var container = Transformable.fromRect(dimensions.tileContainer(coordinate));
    Matchable? matchable;
    if (matchables != null && matchables.isNotEmpty) {
      matchable = Matchable.random(from: matchables, special: special);
    }
    return Tile(UniqueKey(), container, matchable, blocker, collectible);
  }

  const Tile(this.key, this.container, this.matchable, this.blocker, this.collectible);

  Tile clone({Transformable? container, Matchable? matchable, Blocker? blocker, Collectible? collectible}) {
    return Tile(
      key,
      container ?? this.container,
      matchable ?? this.matchable,
      blocker ?? this.blocker,
      collectible ?? this.collectible,
    );
  }

  // Tile fill() {
  //   return Tile(key, matchable, blocker, collectible, container);
  // }

  // identifiers
  final Key key;

  // content
  final Matchable? matchable;
  final Blocker? blocker;
  final Collectible? collectible;

  // transformations
  final Transformable container;

  @override
  List<Object?> get props => [matchable, blocker, collectible, container];
}

extension TileHelper on Tile {
  Color? get color => matchable?.color() ?? blocker?.color();

  MapEntry<Key, Tile> toMapEntry() => MapEntry(key, this);
}

extension TileDebugger on Tile {
  debug() {
    print('>---');
    String coordinates = 'x: ${container.left} y: ${container.top}';
    if (matchable != null) print('tile match: ${matchable?.match.name} $coordinates');
    if (blocker != null) print('tile blocker: ${blocker?.type.name} $coordinates');
    if (collectible != null) print('tile collectible: ${collectible?.type.name} $coordinates');
  }
}
