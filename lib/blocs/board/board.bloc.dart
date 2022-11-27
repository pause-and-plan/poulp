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

class BoardMoves {
  static int initialAmount = 5;
}

class BoardScore {
  static int boxScore = 40;
}

enum BoardSwapStatus { listening, started, inProgress, blockedDuringAnimation }

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardState.initial(BoardMoves.initialAmount)) {
    on<BoardReady>((event, emit) {
      emit(buildReadyState());
    });

    on<BoxSwapStart>((event, emit) {
      if (swapStatus != BoardSwapStatus.blockedDuringAnimation) {
        swapStatus = BoardSwapStatus.started;
        handleDragStart(event.position);
        emit(buildReadyState());
      }
    });

    on<BoxSwapUpdate>((event, emit) {
      if (swapStatus == BoardSwapStatus.started || swapStatus == BoardSwapStatus.inProgress) {
        swapStatus = BoardSwapStatus.inProgress;
        handleDragUpdate(event.position, event.delta);
        emit(buildReadyState());
      }
    });

    on<BoxSwapEnd>((event, emit) {
      if (swapStatus == BoardSwapStatus.inProgress) {
        swapStatus = BoardSwapStatus.blockedDuringAnimation;
        handleDragEnd();
        emit(buildReadyState());
      }
    });

    on<InsertNewBoxes>((event, emit) {
      emit(buildReadyState());
    });

    on<RemoveBoxes>((event, emit) {
      emit(buildReadyState());
    });

    generateBoard();
    add(BoardReady());
  }

  buildReadyState() {
    return BoardState.ready(allBoxes, score, movesLeft);
  }

  handleSuccessfulSwap() async {
    movesLeft--;
    while (isThereSomethingToCrush()) {
      cascadeIndex++;
      scaleDownBoxes();
      insertNewBoxes();
      add(InsertNewBoxes());
      await Future.delayed(const Duration(milliseconds: 400));
      removeBoxes();
      add(RemoveBoxes());
      await Future.delayed(const Duration(milliseconds: 200));
    }
    swapStatus = BoardSwapStatus.listening;
    cascadeIndex = 0;
  }

  int cascadeIndex = 0;
  int score = 0;
  int movesLeft = BoardMoves.initialAmount;

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
