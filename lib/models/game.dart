import 'package:poulp/helpers/random.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/tiles.dart';
import 'package:poulp/repositories/levels/level.dart';

// 1. generateFromLevel DONE
// 2. swapTiles
// 3. explodingReaction
// 4. reset

class Game {
  Game.fromLevel(this.level) {
    random.init(level.randomSeed);
    tiles.initFromLevel(level);
  }

  Level level;
  List<Tile> tiles = [];
  int score = 0;
  int movesLeft = 0;
}
