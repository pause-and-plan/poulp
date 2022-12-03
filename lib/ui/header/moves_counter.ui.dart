// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:poulp/blocs/board/board.bloc.dart';

// class MovesState {
//   MovesState(this.amountLeft);

//   final int amountLeft;
// }

// class MovesCounterUI extends StatelessWidget {
//   const MovesCounterUI({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//       Container(
//           padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue.shade50),
//           child: Row(children: [
//             const Icon(
//               Icons.swipe,
//               size: 40,
//               color: Color(0xff1c2550),
//             ),
//             const SizedBox(width: 10),
//             BlocSelector<BoardBloc, BoardState, MovesState>(selector: ((state) {
//               return MovesState(state.movesLeft);
//             }), builder: ((context, state) {
//               return Text(
//                 state.amountLeft.toString(),
//                 style: const TextStyle(
//                   fontSize: 40,
//                   color: Color(0xff1c2550),
//                 ),
//               );
//             }))
//           ]))
//     ]);
//   }
// }
