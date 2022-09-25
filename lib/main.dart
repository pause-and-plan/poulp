import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poulp/blocs/board/board.bloc.dart';
import 'package:poulp/ui/game.ui.dart';

void main() {
  runApp(const PoulpQuest());
}

class PoulpQuest extends StatelessWidget {
  const PoulpQuest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Poulp quest',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (BuildContext context) => BoardBloc(),
          child: const GameUI(title: 'Game'),
        ));
  }
}
