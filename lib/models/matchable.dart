import 'dart:math';

import 'package:poulp/helpers/random.dart';

enum Matchables { purple, blue, green, yellow, orange, red }

enum SpecialMatchables { horizontal, vertical, bomb }

class Matchable {
  Matchable.random({this.special}) {
    int randomIndex = random.nextInt(Matchables.values.length);
    match = Matchables.values[randomIndex];
  }

  Matchables match = Matchables.purple;
  SpecialMatchables? special;
}
