import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/models/box/box.dart';
import 'package:poulp/blocs/board/helpers/board_generator.dart';
import 'package:poulp/blocs/board/helpers/board_crusher.dart';
import 'package:poulp/blocs/board/helpers/board_swapper.dart';

part 'board.events.dart';
part 'board.state.dart';
part 'box.state.dart';

class BoardDimensions {
  static int rows = 8;
  static int columns = 7;
  static int get length => rows * columns;
}

enum BoardSwapStatus { listening, started, inProgress, blockedDuringAnimation }

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardState.initial()) {
    on<BoardReady>((event, emit) {
      emit(BoardState.ready(allBoxes));
    });

    on<BoxSwapStart>((event, emit) {
      if (swapStatus != BoardSwapStatus.blockedDuringAnimation) {
        swapStatus = BoardSwapStatus.started;
        handleDragStart(event.position);
        emit(BoardState.ready(allBoxes));
      }
    });

    on<BoxSwapUpdate>((event, emit) {
      if (swapStatus == BoardSwapStatus.started || swapStatus == BoardSwapStatus.inProgress) {
        swapStatus = BoardSwapStatus.inProgress;
        handleDragUpdate(event.position, event.delta);
        emit(BoardState.ready(allBoxes));
      }
    });

    on<BoxSwapEnd>((event, emit) {
      if (swapStatus == BoardSwapStatus.inProgress) {
        swapStatus = BoardSwapStatus.blockedDuringAnimation;
        handleDragEnd();
        emit(BoardState.ready(allBoxes));
      }
    });

    on<InsertNewBoxes>((event, emit) {
      emit(BoardState.ready(allBoxes));
    });

    on<RemoveBoxes>((event, emit) {
      emit(BoardState.ready(allBoxes));
    });

    generateBoard();
    add(BoardReady());
  }

  handleSuccessfulSwap() async {
    while (isThereSomethingToCrush()) {
      scaleDownBoxes();
      insertNewBoxes();
      add(InsertNewBoxes());
      await Future.delayed(const Duration(milliseconds: 800));
      removeBoxes();
      add(RemoveBoxes());
      await Future.delayed(const Duration(milliseconds: 200));
    }
    swapStatus = BoardSwapStatus.listening;
  }

  BoardSwapStatus swapStatus = BoardSwapStatus.listening;
  List<Box> boxes = List.generate(BoardDimensions.length, Box.generate);
  List<List<Box>> newBoxes = List.generate(BoardDimensions.columns, (_) => List.empty(growable: true));
  List<Box> get allBoxes => [
        ...newBoxes.reduce((value, element) => [...value, ...element]),
        ...boxes,
      ];
  Offset dragStart = Offset.zero;
  Offset dragDirection = Offset.zero;
  int dragIndex = -1;
}
