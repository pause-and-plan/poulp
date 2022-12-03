import 'package:poulp/helpers/random.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/tiles.dart';
import 'package:poulp/repositories/levels/level.dart';

// [*] Generate grid from json level
// [ ] Show grid on the screen
// [ ] Swap tiles
// [ ] Exploding reaction
// [ ] Score
// [ ] Movements
// [ ] Reset

class Game {
  Game(this.level, this.tiles, this.score, this.movesLeft);
  Game.fromLevel(this.level) {
    random.init(level.randomSeed);
    tiles.initFromLevel(level);
  }

  Game clone() => Game(level, tiles.clone(), score, movesLeft);

  Level level;
  List<Tile> tiles = [];
  int score = 0;
  int movesLeft = 0;
}
