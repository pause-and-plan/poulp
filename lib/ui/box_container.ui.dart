import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/ui/box.ui.dart';

class BoxContainerUI extends StatelessWidget {
  const BoxContainerUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameBloc, GameState, Tile?>(
      selector: ((state) {
        try {
          return state.tiles.firstWhere((element) => element.key == key);
        } catch (error) {
          return null;
        }
      }),
      builder: ((context, state) {
        if (state == null) {
          return const SizedBox.shrink();
        }
        return AnimatedPositioned(
          left: state.container.left,
          top: state.container.top,
          duration: state.container.duration,
          child: BoxUI(key: key),
        );
      }),
    );
  }
}
