import 'dart:math';

import 'package:poulp/helpers/random.dart';

// enum Matchables { purple, blue, green, yellow, orange, red }
enum Matchables { purple, blue }

enum SpecialMatchables { horizontal, vertical, bomb }

class Matchable {
  Matchable.random({List<Matchables> from = Matchables.values, this.special}) {
    int randomIndex = random.nextInt(from.length);
    match = from[randomIndex];
  }

  Matchables match = Matchables.purple;
  SpecialMatchables? special;
}
