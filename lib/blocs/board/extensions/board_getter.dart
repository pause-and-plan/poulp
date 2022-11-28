import 'package:flutter/material.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/extensions/list.dart';
import 'package:poulp/models/box/box.dart';

extension BoardGetter on BoardBloc {
  Box? box(int? index) => boxes.safeElementAt(index);
  int column(index) => index % BoardDimensions.columns;
  int row(int index) => index ~/ BoardDimensions.columns;

  int? horizontalBox(int index, {int distance = 1}) {
    if (index < 0 || boxes.length <= index) {
      return null;
    }

    int horizontalIndex = index + distance;

    if (horizontalIndex < 0 || boxes.length <= horizontalIndex) {
      return null;
    }
    if (row(index) != row(horizontalIndex)) {
      return null;
    }
    return horizontalIndex;
  }

  int? verticalBox(int index, {int distance = 1}) {
    if (index < 0 || boxes.length <= index) {
      return null;
    }

    int verticalIndex = index + distance * BoardDimensions.columns;

    if (verticalIndex < 0 || boxes.length <= verticalIndex) {
      return null;
    }
    if (column(index) != column(verticalIndex)) {
      return null;
    }
    return verticalIndex;
  }

  int? distantBox(int index, Offset offset) {
    if (index < 0 || boxes.length <= index) {
      return null;
    }
    if (offset == Offset.zero) {
      return null;
    }
    if (verticalBox(index, distance: offset.dy.toInt()) == null) {
      return null;
    }
    if (horizontalBox(index, distance: offset.dx.toInt()) == null) {
      return null;
    }

    int distantIndex = index + offset.dx.toInt() + offset.dy.toInt() * BoardDimensions.columns;

    if (distantIndex < 0 || boxes.length <= distantIndex) {
      return null;
    }
    return distantIndex;
  }

  int? top(int index, {int distance = 1}) => verticalBox(index, distance: -distance);
  int? bottom(int index, {int distance = 1}) => verticalBox(index, distance: distance);
  int? left(int index, {int distance = 1}) => horizontalBox(index, distance: -distance);
  int? right(int index, {int distance = 1}) => horizontalBox(index, distance: distance);

  List<int> getBoxAlignedVerticaly(int index) {
    List<int> indexes = [index];

    if (box(index)?.type == null) {
      return indexes;
    }

    for (int? i = bottom(index); i != null; i = bottom(i)) {
      if (box(i)?.type == box(index)?.type) {
        indexes.insert(0, i);
      } else {
        break;
      }
    }

    for (int? i = top(index); i != null; i = top(i)) {
      if (box(i)?.type == box(index)?.type) {
        indexes.add(i);
      } else {
        break;
      }
    }

    return indexes;
  }

  List<int> getBoxAlignedHorizontally(int index) {
    List<int> indexes = [index];

    if (box(index)?.type == null) {
      return indexes;
    }

    for (int? i = left(index); i != null; i = left(i)) {
      if (box(i)?.type == box(index)?.type) {
        indexes.insert(0, i);
      } else {
        break;
      }
    }

    for (int? i = right(index); i != null; i = right(i)) {
      if (box(i)?.type == box(index)?.type) {
        indexes.add(i);
      } else {
        break;
      }
    }

    return indexes;
  }

  List<Key> _getMatch3BoxKeys(int index, int? Function(int, {int distance}) getNextIndex) {
    List<Key> list = List.empty(growable: true);

    for (int? i = getNextIndex(index); i != null; i = getNextIndex(i)) {
      Box? currentBox = box(i);
      if (currentBox != null && currentBox.type == box(index)?.type) {
        list.add(currentBox.key);
      } else {
        break;
      }
    }
    return list;
  }

  List<Key> _getVerticalMatch3BoxKeysByIndex(int index) {
    List<Key> list = List.empty(growable: true);
    Box? currentBox = box(index);

    if (currentBox == null) {
      return List.empty();
    }

    list.addAll(_getMatch3BoxKeys(index, top));
    list.addAll(_getMatch3BoxKeys(index, bottom));

    if (list.length < 2) {
      return List.empty();
    }

    list.add(currentBox.key);
    return list;
  }

  List<Key> _getHorizontalMatch3BoxKeysByIndex(int index) {
    List<Key> list = List.empty(growable: true);
    Box? currentBox = box(index);

    if (currentBox == null) {
      return List.empty();
    }

    list.addAll(_getMatch3BoxKeys(index, left));
    list.addAll(_getMatch3BoxKeys(index, right));

    if (list.length < 2) {
      return List.empty();
    }

    list.add(currentBox.key);
    return list;
  }

  List<Key> _getMatch3BoxKeysByIndex(int index) {
    List<Key> list = List.empty(growable: true);

    list.addAll(_getVerticalMatch3BoxKeysByIndex(index));
    list.addAll(_getHorizontalMatch3BoxKeysByIndex(index));

    return list;
  }

  List<Key> getAllMatch3BoxKeys() {
    List<Key> list = List.empty(growable: true);

    for (int index = 0; index < boxes.length; index++) {
      list.addAll(_getMatch3BoxKeysByIndex(index));
    }

    return list.toSet().toList();
  }

  Key? getKeyByIndex(int index) {
    if (index < 0 || boxes.length <= index) {
      return null;
    }
    return boxes[index].key;
  }

  int? getIndexByKey(Key key) {
    for (int i = 0; i < boxes.length; i++) {
      if (boxes[i].key == key) {
        return i;
      }
    }
    return null;
  }
}
