part of 'game_bloc.dart';

enum GameStatus { initial, ready, busy }

class GameState extends Equatable {
  const GameState(
    this.status,
    this.level,
    this.tiles,
    this.grid,
    this.transformations,
    this.score,
    this.movesLeft,
  );

  final GameStatus status;
  final Level? level;
  final Map<Key, Tile> tiles;
  final Grid grid;
  final Map<Key, Transformation> transformations;
  final int score;
  final int movesLeft;

  @override
  List<Object?> get props => [status, level, tiles, grid, transformations, score, movesLeft];
}

class GameInitial extends GameState {
  GameInitial() : super(GameStatus.initial, null, {}, Grid.empty(), {}, 0, 0);
}
