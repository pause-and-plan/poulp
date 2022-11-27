import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/ui/box_content.ui.dart';

class BoxUI extends StatelessWidget {
  const BoxUI({Key? key}) : super(key: key);

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
        return AnimatedScale(
          scale: state.scale,
          duration: state.scaleDuration,
          child: Container(
            clipBehavior: Clip.none,
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white10,
            ),
            child: BoxContentUI(state.assetPath, key: key),
          ),
        );
      }),
    );
  }
}
