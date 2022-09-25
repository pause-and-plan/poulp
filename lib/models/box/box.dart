import 'package:flutter/material.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/helpers/offset.dart';

enum BoxType { blue, green, yellow, red }

class BoxDimensions {
  static double height = 50;
  static double width = 50;
  static double margin = 2;
  static double get totalHeight => height + margin;
  static double get totalWidth => width + margin;
}

class Box {
  Box.generate(int index) {
    int column = (index % BoardDimensions.columns).toInt();
    int row = (index - column) ~/ BoardDimensions.columns;
    double positionX = column * BoxDimensions.totalWidth;
    double positionY = row * BoxDimensions.totalHeight;

    position = Offset(positionX, positionY);
  }

  final Key key = UniqueKey();

  BoxType? type;
  Offset position = Offset.zero;
  Offset offset = Offset.zero;
  double get left => position.dx + offset.dx;
  double get top => position.dy + offset.dy;
  Duration fallDuration = Duration.zero;
  double scale = 1;
  Duration scaleDuration = Duration.zero;

  Color get color {
    if (type == BoxType.blue) {
      return Colors.blue;
    } else if (type == BoxType.green) {
      return Colors.green;
    } else if (type == BoxType.yellow) {
      return Colors.yellow;
    } else if (type == BoxType.red) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  bool isColliding(Offset event) {
    if (event.dx < left) return false;
    if (event.dx > left + BoxDimensions.width) return false;
    if (event.dy < top) return false;
    if (event.dy > top + BoxDimensions.height) return false;
    return true;
  }

  void move(Offset delta, Offset direction) {
    fallDuration = Duration.zero;
    Offset offsetMax = direction * (BoxDimensions.totalWidth);
    offset += delta.applyDirection(direction);
    offset = offset.sanitize(Offset.zero, offsetMax);
  }

  void swap(Box draggedBox) {
    fallDuration = Duration.zero;
    offset = -draggedBox.offset;
  }
}
