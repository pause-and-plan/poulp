import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/models/matchable.dart';
import 'package:poulp/singletons/dimensions.dart';

class BoxUI extends StatelessWidget {
  const BoxUI({Key? key}) : super(key: key);

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
        return AnimatedScale(
          scale: state.container.scale,
          duration: state.container.duration,
          child: Container(
            clipBehavior: Clip.none,
            height: dimensions.tileHeight.toDouble(),
            width: dimensions.tileWidth.toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: state.color,
            ),
            // child: BoxContentUI(state.assetPath, key: key),
          ),
        );
      }),
    );
  }
}
