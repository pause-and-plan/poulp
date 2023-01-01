import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/models/game/game.dart';
import 'package:poulp/models/grid/transformation.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/grid/grid.dart';
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

    on<TransformationFinished>((event, emit) {
      var transformation = transformations.remove(event.key);

      if (transformations.isNotEmpty) return;

      if (transformation?.type == Transformations.swapFailure) {
        emit(readyState);
      }

      if (transformation?.type == Transformations.swapSuccess) {
        emit(busyState);
        add(TileExplode());
      }

      if (transformation?.type == Transformations.explode) {
        add(TileFall());
      }

      if (transformation?.type == Transformations.fall) {
        add(TileExplode());
      }
    });

    on<TileSwap>((event, emit) async {
      if (state.status != GameStatus.ready) return;

      var point = Grid.getCoordinateFromPosition(event.start);
      if (point == null) return;
      Key? from = game.grid.getTile(point);
      if (from == null) return;
      Key? to = game.grid.getSideTileByDelta(from, event.delta);
      if (to == null) return;

      if (game.tiles[from]?.blocker != null || game.tiles[to]?.blocker != null) {
        print("Cannot swap blockers");
        return;
      }

      var temporaryGrid = game.grid.clone();
      var translations = temporaryGrid.swapTiles(from, to);
      bool canSwap = game.tiles.containMatch(temporaryGrid);
      if (!canSwap) {
        print("Cannot swap tiles");
        transformations[from] = Transformation.swapFailure(translations[from]);
        transformations[to] = Transformation.swapFailure(translations[to]);
        emit(busyState);
        return;
      }

      transformations[from] = Transformation.swapSuccess(translations[from]);
      transformations[to] = Transformation.swapSuccess(translations[to]);
      emit(busyState);

      game.grid.swapTiles(from, to);
    });

    on<TileExplode>((event, emit) {
      // emit(busyState);
      //   await Future.delayed(swapAnimations.successDuration);
      //   game.tiles.flatten();

      //   int cascadeIndex = 0;
      //   while (game.tiles.containMatch()) {
      //     // generate matching groups
      //     // generate specials collaterals
      //     //
      //     cascadeIndex++;
      //     explodingTiles = game.explodeTiles();
      //     game.triggerExplodingAnimation(explodingTiles);
      //     emit(busyState);
      //     await Future.delayed(explodeAnimations.duration);

      //     var fallDuration = game.triggerFallingAnimation(explodingTiles);
      //     var spawns = game.spawnTiles();
      //     game.triggerSpawnFallAnimation(spawns);
      //     explodingTiles.clear();
      //     emit(busyState);
      //     await Future.delayed(fallDuration + const Duration(milliseconds: 0));
      //     game.tiles.flatten();
      //   }

      //   history.add(game.clone());
      //   emit(readyState);
      // } catch (error) {
      //   print('error $error');
      // emit(readyState);
      // }
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

  GameState get readyState => GameState(
        GameStatus.ready,
        game.level,
        Map.from(game.tiles)..addAll(explodingTiles),
        game.grid.unmodifiable(),
        Map.unmodifiable(transformations),
        game.score,
        game.movesLeft,
      );

  GameState get busyState => GameState(
        GameStatus.busy,
        game.level,
        Map.from(game.tiles)..addAll(explodingTiles),
        game.grid.unmodifiable(),
        Map.unmodifiable(transformations),
        game.score,
        game.movesLeft,
      );

  LevelsRepository levels;
  late List<Game> history;
  late Game game;
  Map<Key, Transformation> transformations = {};

  Map<Key, Tile> explodingTiles = {};
}
