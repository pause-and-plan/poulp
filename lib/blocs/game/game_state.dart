part of 'game_bloc.dart';

enum GameStatus { initial, ready, busy }

abstract class GameState extends Equatable {
  const GameState(this.status, this.level, this.tiles, this.score, this.movesLeft);

  final GameStatus status;
  final Level? level;
  final List<Tile> tiles;
  final int score;
  final int movesLeft;

  @override
  List<Object?> get props => [status, level, tiles, score, movesLeft];
}

class GameInitial extends GameState {
  GameInitial() : super(GameStatus.initial, null, [], 0, 0);
}

class GameReady extends GameState {
  const GameReady(Level level, List<Tile> tiles, int score, int movesLeft)
      : super(GameStatus.ready, level, tiles, score, movesLeft);
}

class GameBusy extends GameState {
  const GameBusy(Level level, List<Tile> tiles, int score, int movesLeft)
      : super(GameStatus.busy, level, tiles, score, movesLeft);
}
