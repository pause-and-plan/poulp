import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/models/tile.dart';
import 'package:poulp/singletons/dimensions.dart';

class BoxUI extends StatelessWidget {
  const BoxUI({super.key, required this.tileKey});

  final Key? tileKey;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameBloc, GameState, Tile?>(
      selector: ((state) {
        return state.tiles[tileKey];
      }),
      builder: ((context, state) {
        if (state == null) {
          return const SizedBox.shrink();
        }
        return AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 200),
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
