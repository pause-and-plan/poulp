import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/singletons/dimensions.dart';

class BoxUI extends StatelessWidget {
  const BoxUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameBloc, GameState, Tile?>(
      selector: ((state) {
        return state.tiles[key];
      }),
      builder: ((context, state) {
        if (state == null) {
          return const SizedBox.shrink();
        }
        return AnimatedScale(
          scale: state.container.scaling.value,
          duration: state.container.scaling.duration,
          child: Container(
            clipBehavior: Clip.none,
            height: dimensions.tileHeight.toDouble(),
            width: dimensions.tileWidth.toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: state.gradient,
            ),
          ),
        );
      }),
    );
  }
}
