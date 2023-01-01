import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/game/game_bloc.dart';
import 'package:poulp/models/grid/grid.dart';
import 'package:poulp/models/grid/transformation.dart';
import 'package:poulp/models/transformable.dart';
import 'package:poulp/singletons/dimensions.dart';
import 'package:poulp/ui/box.ui.dart';

class BoxContainerUI extends StatefulWidget {
  const BoxContainerUI({super.key, required this.coordinates});

  final Point<int> coordinates;

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
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previous, current) {
        Key? tileKey = current.grid.getTile(widget.coordinates);
        Key? previousTile = previous.grid.getTile(widget.coordinates);
        Key? currentTile = current.grid.getTile(widget.coordinates);
        bool hasChanged = previousTile != currentTile;
        print('${widget.coordinates} [previous $previousTile current $currentTile] hasChanged $hasChanged');
        return hasChanged || current.transformations[tileKey] != null;
      },
      builder: ((context, state) {
        final game = context.read<GameBloc>();
        Key? tileKey = state.grid.getTile(widget.coordinates);
        print('$tileKey ${widget.coordinates}');

        var transformation = state.transformations[tileKey];
        var translation = transformation?.translation ?? const Point(0, 0);

        Rect begin = Rect.fromLTWH(
          widget.coordinates.x * dimensions.tileTranslationX,
          widget.coordinates.y * dimensions.tileTranslationY,
          dimensions.tileTranslationX + 2,
          dimensions.tileTranslationY + 2,
        );
        Rect end = Rect.fromLTWH(
          (widget.coordinates.x + translation.x) * dimensions.tileTranslationX,
          (widget.coordinates.y + translation.y) * dimensions.tileTranslationY,
          dimensions.tileTranslationX + 2,
          dimensions.tileTranslationY + 2,
        );

        if (tileKey != null && transformation?.translation != null) {
          _controller.reset();
          _controller.duration = transformation?.duration ?? const Duration();
          _controller.forward().whenComplete(() {
            if (transformation?.type == Transformations.swapFailure) {
              _controller.reverse().whenComplete(() => {game.add(TransformationFinished(tileKey))});
            } else {
              game.add(TransformationFinished(tileKey));
            }
          });
        }

        return PositionedTransition(
          key: tileKey,
          rect: RelativeRectTween(
            begin: RelativeRect.fromRect(begin, dimensions.gridRect),
            end: RelativeRect.fromRect(end, dimensions.gridRect),
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear)),
          child: BoxUI(tileKey: tileKey),
        );
      }),
    );
  }
}
