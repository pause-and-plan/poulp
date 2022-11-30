import 'package:poulp/helpers/random.dart';
import 'package:poulp/models/blocker.dart';
import 'package:poulp/models/collectible.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/repositories/levels/level.dart';

// 1. generateFromLevel
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

extension TilesGenerator on List<Tile> {
  initFromLevel(Level level) {
    for (int y = 0; y < boardDimensions.height; y++) {
      for (int x = 0; x < boardDimensions.width; x++) {
        TileCodes code = _codeFromYX(level, y, x);
        Tile? tile = _codeToTile(level, code);

        if (tile != null) {
          add(tile);
        }
      }
    }
  }

  TileCodes _codeFromYX(Level level, int y, int x) {
    return level.tileMap[y][x];
  }

  Tile? _codeToTile(Level level, TileCodes code) {
    Tile tile = Tile();

    switch (code) {
      case TileCodes.matchable:
        tile.matchable = Matchable.random();
        break;
      case TileCodes.matchableHorizontal:
        tile.matchable = Matchable.random(special: SpecialMatchables.horizontal);
        break;
      case TileCodes.matchableVertical:
        tile.matchable = Matchable.random(special: SpecialMatchables.vertical);
        break;
      case TileCodes.matchableBomb:
        tile.matchable = Matchable.random(special: SpecialMatchables.bomb);
        break;
      case TileCodes.wrapperLevel1:
        tile.matchable = Matchable.random();
        tile.blocker = Blocker(Blockers.wrapper, level: 0);
        break;
      case TileCodes.wrapperLevel2:
        tile.matchable = Matchable.random();
        tile.blocker = Blocker(Blockers.wrapper, level: 1);
        break;
      case TileCodes.wrapperLevel3:
        tile.matchable = Matchable.random();
        tile.blocker = Blocker(Blockers.wrapper, level: 2);
        break;
      case TileCodes.blockerLevel1:
        tile.blocker = Blocker(Blockers.block, level: 0);
        break;
      case TileCodes.blockerLevel2:
        tile.blocker = Blocker(Blockers.block, level: 1);
        break;
      case TileCodes.blockerLevel3:
        tile.blocker = Blocker(Blockers.block, level: 2);
        break;
      case TileCodes.collectible:
        tile.collectible = Collectible(Collectibles.cherry);
        break;
      default:
        return null;
    }
    return tile;
  }
}

extension TilesAnalyser on List<Tile> {
  bool containMatch() {
    return false;
  }
}

extension TilesDebugger on List<Tile> {
  debug() {
    print('Tiles amount $length');
    for (Tile tile in this) {
      tile.debug();
    }
  }
}
