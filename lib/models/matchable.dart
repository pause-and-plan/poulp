enum Matchables { purple, blue, green, yellow, orange, red }

enum SpecialMatchables { horizontal, vertical, bomb }

class Matchable {
  Matchables match = Matchables.purple;
  SpecialMatchables? special;
}
