import 'package:flutter/material.dart';
import 'package:poulp/components/drop.dart';

class ScoreUI extends StatelessWidget {
  const ScoreUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(60, 10, 10, 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue.shade50),
          child: const Text('0',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff1c2550),
              )),
        ),
        const Positioned(
          left: -6,
          top: -12,
          child: Drop(),
        )
      ],
    );
  }
}
