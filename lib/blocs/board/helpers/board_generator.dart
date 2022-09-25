import 'dart:math';

import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/blocs/board/helpers/board_getter.dart';
import 'package:poulp/models/box/box.dart';

extension BoardGenerator on BoardBloc {
  generateBoard() {
    _assignNextBoxTypeRecursively(0);
  }

  bool _assignNextBoxTypeRecursively(int index) {
    if (index >= boxes.length) {
      return false;
    }

    List<BoxType> options = List.from(BoxType.values, growable: true);
    bool shouldContinue = true;

    while (shouldContinue && options.isNotEmpty) {
      assignRandomBoxType(index, options);
      if (_isBoxValid(index)) {
        shouldContinue = _assignNextBoxTypeRecursively(index + 1);
      } else {
        options.remove(box(index)?.type);
      }
    }

    return shouldContinue;
  }

  assignRandomBoxType(int index, List<BoxType> options) {
    int typeIndex = Random().nextInt(options.length);
    box(index)?.type = options.elementAt(typeIndex);
  }

  bool _isBoxValid(int index) {
    List<int> verticalBoxes = getBoxAlignedVerticaly(index);
    List<int> horizontalBoxes = getBoxAlignedHorizontally(index);

    if (horizontalBoxes.length >= 3 || verticalBoxes.length >= 3) {
      return false;
    }
    return true;
  }
}
