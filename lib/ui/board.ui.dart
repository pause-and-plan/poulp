import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/models/box/box.dart';
import 'package:poulp/ui/box_container.ui.dart';

class BoardUI extends StatelessWidget {
  const BoardUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white24),
      width: BoardDimensions.columns * BoxDimensions.totalWidth + 10,
      height: BoardDimensions.rows * BoxDimensions.totalHeight + 10,
      child: GestureDetector(
        onPanStart: (details) {
          context.read<BoardBloc>().add(BoxSwapStart(details.localPosition));
        },
        onPanUpdate: (details) {
          context.read<BoardBloc>().add(BoxSwapUpdate(details.localPosition, details.delta));
        },
        onPanEnd: (_) {
          context.read<BoardBloc>().add(BoxSwapEnd());
        },
        child: BlocSelector<BoardBloc, BoardState, List<BoxContainerUI>>(
          selector: ((state) {
            return state.boxes.map((e) => BoxContainerUI(key: e.key)).toList();
          }),
          builder: ((context, state) {
            return Stack(children: state);
          }),
        ),
      ),
    );
  }
}
