import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/game.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/repositories/levels/levels_repository.dart';
import 'package:poulp/singletons/animations.dart';
import 'package:poulp/models/tiles.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(this.levels) : super(GameInitial()) {
    on<GameStart>((event, emit) async {
      history = [];
      game = Game.fromLevel(await levels.getNextIncompleteLevel());
      emit(readyState);
    });

    on<GameRestart>((event, emit) {
      if (history.isNotEmpty) {
        game = history[0];
        history = [];
        emit(readyState);
      }
    });

    on<TileSwap>((event, emit) async {
      if (state.status != GameStatus.ready) return;
      emit(busyState);

      try {
        Tile from = game.getTileByOffset(event.start);
        Tile to = game.getSideTileByDelta(from, event.delta);
        if (from.blocker != null || to.blocker != null) throw Error();

        if (!game.canSwapTiles(from, to)) {
          game.fakeSwapToShowFailure(from, to, swapAnimations.failDuration);
          emit(busyState);
          await Future.delayed(swapAnimations.failDuration);

          game.revertFakeSwap(from, to, swapAnimations.failDuration);
          emit(busyState);
          await Future.delayed(swapAnimations.failDuration);

          game.flattenTiles(from, to);
          throw ErrorDescription("Cannot swap tiles");
        }

        game.swapTiles(from, to, swapAnimations.successDuration);
        emit(busyState);
        await Future.delayed(swapAnimations.successDuration);
        game.flattenTiles(from, to);

        int cascadeIndex = 0;
        while (game.tiles.containMatch()) {
          cascadeIndex++;
          var groups = game.tiles.getMatchingGroups();
          game.tiles.applyMatchingGroups(groups);
          // @TODO Spawn new tiles
          /**
           * Check spawner tiles from level
           * if empty
           *    - continue to check below until a collision is found
           *    - save the amount of empty tile in "spawnColumn"
           *    - generate all tiles and inject them in the UI
           *    - set the positionY to 0 - spawnColumnIndex * tileHeight
           *    - set the translationY to spawnColumnIndex * tileHeight
           *    - 
           */
          emit(busyState);
          await Future.delayed(fallAnimations.duration);
          game.tiles.flatten();
        }

        history.add(game.clone());
        emit(readyState);
      } catch (error) {
        print('error $error');
        emit(readyState);
      }
    });

    on<Undo>((event, emit) {
      if (history.isNotEmpty) {
        game = history.last.clone();
        history.removeLast();
        emit(readyState);
      }
    });

    add(GameStart());
  }

  GameState get readyState => GameReady(game.level, game.tiles.values.toList(), game.score, game.movesLeft);
  GameState get busyState => GameBusy(game.level, game.tiles.values.toList(), game.score, game.movesLeft);

  LevelsRepository levels;
  late List<Game> history;
  late Game game;
}
