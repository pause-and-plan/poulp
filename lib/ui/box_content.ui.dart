import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:rive/rive.dart';

class BoxContentUI extends StatefulWidget {
  const BoxContentUI(this.asset, {Key? key}) : super(key: key);

  final String asset;

  @override
  BoxContentUIState createState() => BoxContentUIState();
}

class BoxContentUIState extends State<BoxContentUI> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SpeedController('Collapse', speedMultiplier: 2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardBloc, BoardState>(
        listener: (context, state) {
          try {
            BoxState box = state.boxes.firstWhere((element) => element.key == widget.key);
            if (box.shouldCollapse) {
              setState(() {
                _controller.isActive = true;
              });
            }
          } catch (_) {}
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -4,
              top: -8,
              child: SizedBox(
                width: 60,
                height: 60,
                child: RiveAnimation.asset(
                  widget.asset,
                  controllers: [_controller],
                ),
              ),
            )
          ],
        ));
  }
}

class SpeedController extends OneShotAnimation {
  final double speedMultiplier;

  SpeedController(
    String animationName, {
    double mix = 1,
    this.speedMultiplier = 1,
  }) : super(animationName, mix: mix, autoplay: false);

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (instance == null || !instance!.keepGoing) {
      isActive = false;
    }
    instance!
      ..animation.apply(instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds * speedMultiplier);
  }
}
