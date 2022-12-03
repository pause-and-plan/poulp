import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/game.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/repositories/levels/levels_repository.dart';
import 'package:poulp/singletons/animations.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(this.levels) : super(GameInitial()) {
    on<GameStart>((event, emit) async {
      history = [];
      game = Game.fromLevel(await levels.getNextIncompleteLevel());
      emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
    });

    on<GameRestart>((event, emit) {
      if (history.isNotEmpty) {
        game = history[0];
        history = [];
        emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
      }
    });

    on<TileSwap>((event, emit) async {
      if (state.status != GameStatus.ready) return;
      emit(GameBusy(game.level, game.tiles, game.score, game.movesLeft));

      try {
        Tile from = game.getTileByOffset(event.start);
        Tile to = game.getSideTileByDelta(from, event.delta);
        game.swapTiles(from, to);
        emit(GameBusy(game.level, game.tiles, game.score, game.movesLeft));

        await Future.delayed(swapAnimations.successDuration);
        from.container.flatten();
        to.container.flatten();
        history.add(game.clone());
        emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
      } catch (error) {
        await Future.delayed(swapAnimations.failDuration);
        emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
      }
    });

    on<Undo>((event, emit) {
      if (history.isNotEmpty) {
        game = history.last.clone();
        history.removeLast();
        emit(GameReady(game.level, game.tiles, game.score, game.movesLeft));
      }
    });

    add(GameStart());
  }

  LevelsRepository levels;
  late List<Game> history;
  late Game game;
}
