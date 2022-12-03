import 'dart:math';

import 'package:poulp/helpers/random.dart';
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
