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
    _controller = OneShotAnimation(
      'Collapse',
      autoplay: false,
    );
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
      child: RiveAnimation.asset(
        widget.asset,
        controllers: [_controller],
      ),
    );
  }
}
