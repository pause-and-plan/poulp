import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/logic/board_bloc/board_bloc.dart';
import 'package:poulp/logic/board_bloc/board_bloc.events.dart';
import 'package:poulp/logic/board_bloc/entities/board.dart';
import 'package:poulp/logic/board_bloc/entities/board_getter.dart';
import 'package:poulp/logic/board_bloc/entities/board_crusher.dart';
import 'package:poulp/logic/board_bloc/entities/board_swapper.dart';
import 'package:poulp/logic/board_bloc/entities/box.dart';
import 'package:poulp/screens/game/board/box.ui.dart';
import 'package:poulp/helpers/list.dart';

class BoardUI extends StatefulWidget {
  const BoardUI({Key? key}) : super(key: key);

  @override
  State<BoardUI> createState() => _BoardUIState();
}

class _BoardUIState extends State<BoardUI> {
  @override
  Widget build(BuildContext context) {
    List<Widget> renderBoxes(List<Box> boxes) {
      List<BoxUI> cases = boxes.mapI((box, index) => BoxUI(
            key: box.key,
            box: box,
            index: index,
          ));
      return cases;
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white24),
        width: Board.width + 10,
        height: Board.height + 10,
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
          child: BlocBuilder<BoardBloc, BoardState>(
            builder: (context, state) {
              return Stack(children: renderBoxes(state.boxes));
            },
          ),
        ),
      ),
    );
  }
}
