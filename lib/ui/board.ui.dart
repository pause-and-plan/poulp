import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/singletons/dimensions.dart';
import 'package:poulp/ui/box_container.ui.dart';

class BoardUI extends StatelessWidget {
  const BoardUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameBloc>();

    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: const Color(0xFF33588D)),
      width: dimensions.gridWidth,
      height: dimensions.gridHeight,
      child: GestureDetector(
        onPanStart: (details) {},
        onPanUpdate: (details) {
          // if (details.delta) {
          //   game.add(TileSwap(start, delta));
          // }
        },
        child: BlocSelector<BoardBloc, BoardState, List<BoxContainerUI>>(
          selector: ((state) {
            return state.boxes.map((e) => BoxContainerUI(key: e.key)).toList();
          }),
          builder: ((context, state) {
            return Stack(clipBehavior: Clip.none, children: state);
          }),
        ),
      ),
    );
  }
}
