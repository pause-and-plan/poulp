import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/ui/box.ui.dart';

class BoxContainerUI extends StatelessWidget {
  const BoxContainerUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BoardBloc, BoardState, BoxState?>(
      selector: ((state) {
        try {
          return state.boxes.firstWhere((element) => element.key == key);
        } catch (error) {
          return null;
        }
      }),
      builder: ((context, state) {
        if (state == null) {
          return const SizedBox.shrink();
        }
        return AnimatedPositioned(
          left: state.left,
          top: state.top,
          duration: state.fallDuration,
          child: BoxUI(key: key),
        );
      }),
    );
  }
}
