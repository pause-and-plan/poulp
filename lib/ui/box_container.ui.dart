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
      builder: ((context, container) {
        if (container == null) {
          return const SizedBox.shrink();
        }

        if (container.translation.offset != Offset.zero) {
          _controller.reset();
          _controller.duration = container.translation.duration;
          _controller.forward().whenComplete(() {
            if (container.translation.revert) {
              _controller.reverse();
            }
          });
        }

        return PositionedTransition(
          key: widget.key,
          rect: RelativeRectTween(
            begin: RelativeRect.fromRect(container.box, dimensions.gridRect),
            end: RelativeRect.fromRect(container.translatedBox, dimensions.gridRect),
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
          child: BoxUI(key: widget.key),
        );
      }),
    );
  }
}
