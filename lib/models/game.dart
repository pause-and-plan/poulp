import 'package:poulp/models/tile.dart';
import 'package:poulp/repositories/levels/level.dart';

class Game {
  Game(this.level);

  Level level;
  int score = 0;
  int movesLeft = 0;
  List<Tile> tiles = [];
}
