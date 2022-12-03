part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameStart extends GameEvent {}

class Undo extends GameEvent {}

class GameRestart extends GameEvent {}

class TileSwap extends GameEvent {
  const TileSwap(this.start, this.delta);

  final Offset start;
  final Offset delta;

  @override
  List<Object> get props => [start, delta];
}
