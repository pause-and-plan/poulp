import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/game.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/repositories/levels/level.dart';
import 'package:poulp/repositories/levels/levels_repository.dart';
import 'package:poulp/singletons/animations.dart';
import 'package:poulp/models/tiles.dart';
import 'package:poulp/ui/box_container.ui.dart';

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
          await Future.delayed(swapAnimations.failTotalDuration);
          game.revertSwap(from, to);
          throw ErrorDescription("Cannot swap tiles");
        }

        game.swapTiles(from, to, swapAnimations.successDuration);
        emit(busyState);
        await Future.delayed(swapAnimations.successDuration);
        game.tiles.flatten();

        int cascadeIndex = 0;
        while (game.tiles.containMatch()) {
          cascadeIndex++;
          explodingTiles = game.explodeTiles();
          game.triggerExplodingAnimation(explodingTiles);
          emit(busyState);
          await Future.delayed(explodeAnimations.duration);

          var fallDuration = game.triggerFallingAnimation(explodingTiles);
          var spawns = game.spawnTiles();
          game.triggerSpawnFallAnimation(spawns);
          explodingTiles.clear();
          emit(busyState);
          await Future.delayed(fallDuration + const Duration(milliseconds: 0));
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

  GameState get readyState => GameReady(
        game.level,
        Map.from(game.tiles)..addAll(explodingTiles),
        game.score,
        game.movesLeft,
      );
  GameState get busyState => GameBusy(
        game.level,
        Map.from(game.tiles)..addAll(explodingTiles),
        game.score,
        game.movesLeft,
      );

  LevelsRepository levels;
  late List<Game> history;
  late Game game;
  Map<Key, Tile> explodingTiles = {};
}
