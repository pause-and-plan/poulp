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
    Map<Key, BoxContainerUI> boxes = {};

    return BlocBuilder<GameBloc, GameState>(
      builder: ((context, state) {
        boxes.removeWhere((key, _) => state.tiles[key] == null);
        state.tiles.forEach((key, value) {
          if (boxes[key] == null || value.container.translation.offset != Offset.zero) {
            boxes[key] = BoxContainerUI(key: key);
          }
        });

        return Stack(
          key: stackKey,
          clipBehavior: Clip.hardEdge,
          children: boxes.values.toList(),
        );
      }),
    );
  }
}
