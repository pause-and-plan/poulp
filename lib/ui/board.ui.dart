import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/singletons/dimensions.dart';
import 'package:poulp/ui/box_container.ui.dart';

class BoardUI extends StatelessWidget {
  const BoardUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameBloc>();
    Offset start = Offset.zero;
    bool isSwapEventSent = false;

    return Container(
      // clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(top: 100),
      padding: EdgeInsets.all(dimensions.gridPadding),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: const Color(0xFF33588D)),
      width: dimensions.gridWidth,
      height: dimensions.gridHeight,
      child: GestureDetector(
          onPanStart: (details) => start = details.localPosition,
          onPanUpdate: (details) {
            if (isSwapEventSent) return;

            Offset delta = details.localPosition - start;
            if (delta.dx.abs() > 1 || delta.dy.abs() > 1) {
              isSwapEventSent = true;
              game.add(TileSwap(start, delta));
            }
          },
          onPanEnd: (_) => isSwapEventSent = false,
          child: BlocSelector<GameBloc, GameState, List<Widget>>(
            selector: ((state) {
              return state.tileContainers;
            }),
            builder: ((context, state) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: state,
              );
            }),
          )),
    );
  }
}
