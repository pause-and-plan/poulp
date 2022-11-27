import 'package:flutter/material.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/blocs/board/helpers/board_getter.dart';
import 'package:poulp/models/box/box.dart';

extension BoardSwapper on BoardBloc {
  int get swappedBoxIndex => distantBox(dragIndex, dragDirection) ?? -1;
  Offset get swapDirection => Offset(-dragDirection.dx, -dragDirection.dy);
  Box? get draggedBox => box(dragIndex);
  Box? get swappedBox => box(swappedBoxIndex);

  handleDragStart(Offset position) {
    dragStart = position;
    dragIndex = boxes.lastIndexWhere((box) => box.isColliding(position));
  }

  handleDragUpdate(Offset position, Offset delta) {
    if (draggedBox == null) {
      return;
    }

    _initDragDirection(dragStart, position);

    if (swappedBox == null) {
      return;
    }

    draggedBox?.move(delta, dragDirection);
    swappedBox?.swap(draggedBox!);
  }

  handleDragEnd() {
    if (movesLeft == 0) {
      _resetBoxesMovements();
      swapStatus = BoardSwapStatus.listening;
      return;
    }

    if (draggedBox == null || swappedBox == null) {
      _resetBoxesMovements();
      swapStatus = BoardSwapStatus.listening;
      return;
    }

    _tryToSwapBoxes();
    _resetBoxesMovements();
  }

  _initDragDirection(Offset dragStart, Offset dragUpdate) {
    if (dragDirection != Offset.zero) {
      return;
    }

    Offset delta = dragUpdate - dragStart;

    if (delta.dx.abs() < 1 && delta.dy.abs() < 1) {
      return;
    }

    if (delta.dy.abs() > delta.dx.abs()) {
      dragDirection = Offset(0, delta.dy.sign);
    } else {
      dragDirection = Offset(delta.dx.sign, 0);
    }
  }

  _tryToSwapBoxes() {
    if (_isSwapTresholdReached() == false) {
      swapStatus = BoardSwapStatus.listening;
      return;
    }

    _swapBoxes();
    if (_shouldCrushBoxes(dragIndex) || _shouldCrushBoxes(swappedBoxIndex)) {
      _swapBoxesPositions();
      handleSuccessfulSwap();
      return;
    }
    _swapBoxes();
    swapStatus = BoardSwapStatus.listening;
  }

  bool _shouldCrushBoxes(int index) {
    List<int> verticalBoxes = getBoxAlignedVerticaly(index);
    List<int> horizontalBoxes = getBoxAlignedHorizontally(index);

    if (verticalBoxes.length >= 3) {
      return true;
    }
    if (horizontalBoxes.length >= 3) {
      return true;
    }
    return false;
  }

  bool _isSwapTresholdReached() {
    return draggedBox!.offset.distance > (BoxDimensions.totalWidth) / 3;
  }

  _swapBoxes() {
    if (dragIndex == -1 || swappedBoxIndex == -1) {
      return;
    }

    Box temp = boxes[dragIndex];
    boxes[dragIndex] = boxes[swappedBoxIndex];
    boxes[swappedBoxIndex] = temp;
  }

  _swapBoxesPositions() {
    if (dragIndex == -1 || swappedBoxIndex == -1) {
      return;
    }

    Offset tempPosition = boxes[dragIndex].position;
    boxes[dragIndex].position = boxes[swappedBoxIndex].position;
    boxes[swappedBoxIndex].position = tempPosition;
  }

  _resetBoxesMovements() {
    if (dragIndex != -1 || swappedBoxIndex == -1) {
      boxes[dragIndex].offset = Offset.zero;
    }
    if (swappedBoxIndex != -1) {
      boxes[swappedBoxIndex].offset = Offset.zero;
    }
    dragIndex = -1;
    dragDirection = Offset.zero;
  }
}
