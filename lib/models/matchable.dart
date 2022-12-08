import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/singletons/random.dart';
import 'package:poulp/repositories/levels/level.dart';

enum SpecialMatchables { horizontal, vertical, bomb }

class Matchable extends Equatable {
  static Matchable random({List<Matchables> from = Matchables.values, SpecialMatchables? special}) {
    return Matchable(from[randomProvider.nextInt(from.length)], special);
  }

  const Matchable(this.match, this.special);

  Matchable clone({Matchables? match, SpecialMatchables? special}) {
    return Matchable(match ?? this.match, special ?? this.special);
  }

  final Matchables match;
  final SpecialMatchables? special;

  @override
  List<Object?> get props => [match, special];
}

extension MatchableColor on Matchable {
  Color color() {
    switch (match) {
      case Matchables.purple:
        return shade(Colors.purple);
      case Matchables.blue:
        return shade(Colors.blue);
      case Matchables.green:
        return shade(Colors.green);
      case Matchables.yellow:
        return shade(Colors.yellow);
      case Matchables.orange:
        return shade(Colors.orange);
      case Matchables.red:
        return shade(Colors.red);
    }
  }

  Color shade(MaterialColor color) {
    switch (special) {
      case null:
        return color.withOpacity(0.5);
      case SpecialMatchables.horizontal:
        return color.shade400;
      case SpecialMatchables.vertical:
        return color.shade700;
      case SpecialMatchables.bomb:
        return color.shade900;
    }
  }
}
