import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/game.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/repositories/levels/levels_repository.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(this.levels) : super(GameInitial()) {
    on<GameStart>((event, emit) {
      history = [];
      game = Game.fromLevel(levels.getNextIncompleteLevel());
      emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
    });

    on<GameRestart>((event, emit) {
      if (history.isNotEmpty) {
        game = history[0];
        history = [];
        emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
      }
    });

    on<TileSwap>((event, emit) {
      emit(GameBusy(game.level, game.tiles, game.score, game.movesLeft));
      // apply animations

      history.add(game.clone());
      emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
    });

    on<Undo>((event, emit) {
      if (history.isNotEmpty) {
        game = history.last.clone();
        history.removeLast();
        emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
      }
    });
  }

  LevelsRepository levels;
  late List<Game> history;
  late Game game;
}
