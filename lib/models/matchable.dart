import 'package:flutter/material.dart';
import 'package:poulp/singletons/random.dart';
import 'package:poulp/repositories/levels/level.dart';

enum SpecialMatchables { horizontal, vertical, bomb }

class Matchable {
  Matchable(this.match, this.special);

  Matchable.random({List<Matchables> from = Matchables.values, this.special}) {
    int randomIndex = random.nextInt(from.length);
    match = from[randomIndex];
  }

  Matchable clone() => Matchable(match, special);

  Matchables match = Matchables.purple;
  SpecialMatchables? special;
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
        return color.shade100;
      case SpecialMatchables.horizontal:
        return color.shade400;
      case SpecialMatchables.vertical:
        return color.shade700;
      case SpecialMatchables.bomb:
        return color.shade900;
    }
  }
}
