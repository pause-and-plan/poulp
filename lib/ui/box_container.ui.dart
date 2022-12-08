import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/singletons/dimensions.dart';
import 'package:poulp/ui/box.ui.dart';

class BoxContainerUI extends StatefulWidget {
  const BoxContainerUI({super.key});

  @override
  State<BoxContainerUI> createState() => _BoxContainerUIState();
}

class _BoxContainerUIState extends State<BoxContainerUI> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameBloc, GameState, Transformable?>(
      selector: ((state) {
        return state.tiles[widget.key]?.container;
      }),
      builder: ((context, state) {
        // print('BoxContainerUI ${widget.key}');
        if (state == null) {
          return const SizedBox.shrink();
        }

        if (state.translation.offset != Offset.zero) {
          _controller.duration = state.translation.duration;
          _controller.forward().whenComplete(() {
            if (state.translation.revert) {
              _controller.reverse();
            }
          });
        }

        return PositionedTransition(
          key: widget.key,
          rect: RelativeRectTween(
            begin: RelativeRect.fromRect(state.translationStart, dimensions.gridRect),
            end: RelativeRect.fromRect(state.translationEnd, dimensions.gridRect),
          ).animate(_controller),
          child: BoxUI(key: widget.key),
        );
      }),
    );
  }
}
