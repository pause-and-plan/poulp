import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/blocs/board/extensions/board_getter.dart';
import 'package:poulp/models/box/box.dart';

extension BoardCrusher on BoardBloc {
  bool isThereSomethingToCrush() {
    List<Key> keys = getAllMatch3BoxKeys();
    return keys.isNotEmpty;
  }

  scaleDownBoxes() {
    List<Key> keys = getAllMatch3BoxKeys();
    for (Key key in keys) {
      box(getIndexByKey(key))?.shouldCollapse = true;
      // box(getIndexByKey(key))?.scale = 0.5;
      // box(getIndexByKey(key))?.scaleDuration = const Duration(milliseconds: 200);
    }
  }

  insertNewBoxes() {
    List<Key> keys = getAllMatch3BoxKeys();

    for (Key key in keys) {
      int? index = getIndexByKey(key);

      if (index == null) {
        break;
      }

      Box box = Box.generate(index);
      int column = index % BoardDimensions.columns;
      double left = column * BoxDimensions.totalWidth;
      double top = -BoxDimensions.totalHeight * (newBoxes[column].length + 1);
      box.position = Offset(left, top);
      int typeIndex = Random().nextInt(BoxType.values.length);
      box.type = BoxType.values.elementAt(typeIndex);
      newBoxes[column].add(box);
    }
  }

  removeBoxes() {
    List<Key> keys = getAllMatch3BoxKeys();
    for (Key key in keys) {
      _removeBox(key);
      score += BoardScore.boxScore * cascadeIndex;
    }
  }

  _removeBox(Key key) {
    int? index = getIndexByKey(key);

    if (index == null) {
      return;
    }

    for (int? i = index; i != null; i = top(i)) {
      Box? topBox = box(top(i));
      if (topBox != null) {
        boxes[i] = topBox;
        boxes[i].position += Offset(0, BoxDimensions.totalHeight);
        boxes[i].fallDuration = const Duration(milliseconds: 200);
      }
    }

    int column = index % BoardDimensions.columns;
    boxes[column] = Box.generate(column);
    Box newBox = newBoxes[column].first;
    newBoxes[column].removeAt(0);
    newBox.position = boxes[column].position;
    newBox.fallDuration = const Duration(milliseconds: 200);
    boxes[column] = newBox;
  }
}
