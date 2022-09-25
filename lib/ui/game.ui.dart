import 'package:flutter/material.dart';
import 'package:poulp/ui/board.ui.dart';

class GameUI extends StatefulWidget {
  const GameUI({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GameUI> createState() => _GameUIState();
}

class _GameUIState extends State<GameUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black87,
        child: const Center(child: BoardUI()),
      ),
    );
  }
}
