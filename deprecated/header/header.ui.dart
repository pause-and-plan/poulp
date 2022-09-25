import 'package:flutter/material.dart';
import 'package:poulp/screens/game/header/moves_counter.ui.dart';
import 'package:poulp/screens/game/header/restart.ui.dart';
import 'package:poulp/screens/game/header/score.ui.dart';

class HeaderUI extends StatelessWidget {
  const HeaderUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ScoreUI(),
              Spacer(),
              RestartUI(),
            ],
          ),
        ),
        const SizedBox(height: 50),
        const MovesCounterUI(),
      ],
    );
  }
}
