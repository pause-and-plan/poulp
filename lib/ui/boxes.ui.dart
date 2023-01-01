import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/singletons/dimensions.dart';
import 'package:poulp/ui/box.ui.dart';
import 'package:poulp/ui/box_container.ui.dart';

class BoxesUI extends StatelessWidget {
  const BoxesUI({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey stackKey = GlobalKey();

    return Stack(
      key: stackKey,
      clipBehavior: Clip.hardEdge,
      children: const [
        BoxContainerUI(key: ObjectKey(Point(0, 0)), coordinates: Point(0, 0)),
        BoxContainerUI(key: ObjectKey(Point(1, 0)), coordinates: Point(1, 0)),
        BoxContainerUI(key: ObjectKey(Point(2, 0)), coordinates: Point(2, 0)),
        BoxContainerUI(key: ObjectKey(Point(3, 0)), coordinates: Point(3, 0)),
        BoxContainerUI(key: ObjectKey(Point(4, 0)), coordinates: Point(4, 0)),
        BoxContainerUI(key: ObjectKey(Point(5, 0)), coordinates: Point(5, 0)),
        BoxContainerUI(key: ObjectKey(Point(6, 0)), coordinates: Point(6, 0)),
        BoxContainerUI(key: ObjectKey(Point(7, 0)), coordinates: Point(7, 0)),
        BoxContainerUI(key: ObjectKey(Point(8, 0)), coordinates: Point(8, 0)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 1)), coordinates: Point(0, 1)),
        BoxContainerUI(key: ObjectKey(Point(1, 1)), coordinates: Point(1, 1)),
        BoxContainerUI(key: ObjectKey(Point(2, 1)), coordinates: Point(2, 1)),
        BoxContainerUI(key: ObjectKey(Point(3, 1)), coordinates: Point(3, 1)),
        BoxContainerUI(key: ObjectKey(Point(4, 1)), coordinates: Point(4, 1)),
        BoxContainerUI(key: ObjectKey(Point(5, 1)), coordinates: Point(5, 1)),
        BoxContainerUI(key: ObjectKey(Point(6, 1)), coordinates: Point(6, 1)),
        BoxContainerUI(key: ObjectKey(Point(7, 1)), coordinates: Point(7, 1)),
        BoxContainerUI(key: ObjectKey(Point(8, 1)), coordinates: Point(8, 1)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 2)), coordinates: Point(0, 2)),
        BoxContainerUI(key: ObjectKey(Point(1, 2)), coordinates: Point(1, 2)),
        BoxContainerUI(key: ObjectKey(Point(2, 2)), coordinates: Point(2, 2)),
        BoxContainerUI(key: ObjectKey(Point(3, 2)), coordinates: Point(3, 2)),
        BoxContainerUI(key: ObjectKey(Point(4, 2)), coordinates: Point(4, 2)),
        BoxContainerUI(key: ObjectKey(Point(5, 2)), coordinates: Point(5, 2)),
        BoxContainerUI(key: ObjectKey(Point(6, 2)), coordinates: Point(6, 2)),
        BoxContainerUI(key: ObjectKey(Point(7, 2)), coordinates: Point(7, 2)),
        BoxContainerUI(key: ObjectKey(Point(8, 2)), coordinates: Point(8, 2)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 3)), coordinates: Point(0, 3)),
        BoxContainerUI(key: ObjectKey(Point(1, 3)), coordinates: Point(1, 3)),
        BoxContainerUI(key: ObjectKey(Point(2, 3)), coordinates: Point(2, 3)),
        BoxContainerUI(key: ObjectKey(Point(3, 3)), coordinates: Point(3, 3)),
        BoxContainerUI(key: ObjectKey(Point(4, 3)), coordinates: Point(4, 3)),
        BoxContainerUI(key: ObjectKey(Point(5, 3)), coordinates: Point(5, 3)),
        BoxContainerUI(key: ObjectKey(Point(6, 3)), coordinates: Point(6, 3)),
        BoxContainerUI(key: ObjectKey(Point(7, 3)), coordinates: Point(7, 3)),
        BoxContainerUI(key: ObjectKey(Point(8, 3)), coordinates: Point(8, 3)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 4)), coordinates: Point(0, 4)),
        BoxContainerUI(key: ObjectKey(Point(1, 4)), coordinates: Point(1, 4)),
        BoxContainerUI(key: ObjectKey(Point(2, 4)), coordinates: Point(2, 4)),
        BoxContainerUI(key: ObjectKey(Point(3, 4)), coordinates: Point(3, 4)),
        BoxContainerUI(key: ObjectKey(Point(4, 4)), coordinates: Point(4, 4)),
        BoxContainerUI(key: ObjectKey(Point(5, 4)), coordinates: Point(5, 4)),
        BoxContainerUI(key: ObjectKey(Point(6, 4)), coordinates: Point(6, 4)),
        BoxContainerUI(key: ObjectKey(Point(7, 4)), coordinates: Point(7, 4)),
        BoxContainerUI(key: ObjectKey(Point(8, 4)), coordinates: Point(8, 4)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 5)), coordinates: Point(0, 5)),
        BoxContainerUI(key: ObjectKey(Point(1, 5)), coordinates: Point(1, 5)),
        BoxContainerUI(key: ObjectKey(Point(2, 5)), coordinates: Point(2, 5)),
        BoxContainerUI(key: ObjectKey(Point(3, 5)), coordinates: Point(3, 5)),
        BoxContainerUI(key: ObjectKey(Point(4, 5)), coordinates: Point(4, 5)),
        BoxContainerUI(key: ObjectKey(Point(5, 5)), coordinates: Point(5, 5)),
        BoxContainerUI(key: ObjectKey(Point(6, 5)), coordinates: Point(6, 5)),
        BoxContainerUI(key: ObjectKey(Point(7, 5)), coordinates: Point(7, 5)),
        BoxContainerUI(key: ObjectKey(Point(8, 5)), coordinates: Point(8, 5)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 6)), coordinates: Point(0, 6)),
        BoxContainerUI(key: ObjectKey(Point(1, 6)), coordinates: Point(1, 6)),
        BoxContainerUI(key: ObjectKey(Point(2, 6)), coordinates: Point(2, 6)),
        BoxContainerUI(key: ObjectKey(Point(3, 6)), coordinates: Point(3, 6)),
        BoxContainerUI(key: ObjectKey(Point(4, 6)), coordinates: Point(4, 6)),
        BoxContainerUI(key: ObjectKey(Point(5, 6)), coordinates: Point(5, 6)),
        BoxContainerUI(key: ObjectKey(Point(6, 6)), coordinates: Point(6, 6)),
        BoxContainerUI(key: ObjectKey(Point(7, 6)), coordinates: Point(7, 6)),
        BoxContainerUI(key: ObjectKey(Point(8, 6)), coordinates: Point(8, 6)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 7)), coordinates: Point(0, 7)),
        BoxContainerUI(key: ObjectKey(Point(1, 7)), coordinates: Point(1, 7)),
        BoxContainerUI(key: ObjectKey(Point(2, 7)), coordinates: Point(2, 7)),
        BoxContainerUI(key: ObjectKey(Point(3, 7)), coordinates: Point(3, 7)),
        BoxContainerUI(key: ObjectKey(Point(4, 7)), coordinates: Point(4, 7)),
        BoxContainerUI(key: ObjectKey(Point(5, 7)), coordinates: Point(5, 7)),
        BoxContainerUI(key: ObjectKey(Point(6, 7)), coordinates: Point(6, 7)),
        BoxContainerUI(key: ObjectKey(Point(7, 7)), coordinates: Point(7, 7)),
        BoxContainerUI(key: ObjectKey(Point(8, 7)), coordinates: Point(8, 7)),
        // column
        BoxContainerUI(key: ObjectKey(Point(0, 8)), coordinates: Point(0, 8)),
        BoxContainerUI(key: ObjectKey(Point(1, 8)), coordinates: Point(1, 8)),
        BoxContainerUI(key: ObjectKey(Point(2, 8)), coordinates: Point(2, 8)),
        BoxContainerUI(key: ObjectKey(Point(3, 8)), coordinates: Point(3, 8)),
        BoxContainerUI(key: ObjectKey(Point(4, 8)), coordinates: Point(4, 8)),
        BoxContainerUI(key: ObjectKey(Point(5, 8)), coordinates: Point(5, 8)),
        BoxContainerUI(key: ObjectKey(Point(6, 8)), coordinates: Point(6, 8)),
        BoxContainerUI(key: ObjectKey(Point(7, 8)), coordinates: Point(7, 8)),
        BoxContainerUI(key: ObjectKey(Point(8, 8)), coordinates: Point(8, 8)),
      ],
    );
  }
}
