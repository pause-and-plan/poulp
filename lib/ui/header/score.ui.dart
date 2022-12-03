// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:poulp/blocs/board/board.bloc.dart';
// import 'package:poulp/models/box/box.dart';
// import 'package:rive/rive.dart';

// class ScoreState {
//   final int score;

//   ScoreState(this.score);
// }

// class ScoreUI extends StatefulWidget {
//   const ScoreUI({Key? key}) : super(key: key);

//   @override
//   ScoreUIState createState() => ScoreUIState();
// }

// class ScoreUIState extends State<ScoreUI> {
//   late SpeedController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = SpeedController('Collapse', speedMultiplier: 2);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<BoardBloc, BoardState>(
//       listenWhen: (previousState, currentState) {
//         return previousState.score != currentState.score;
//       },
//       listener: (context, state) {
//         // setState(() {
//         //   _controller.isActive = true;
//         // });
//         // Timer(const Duration(milliseconds: 500), () {
//         //   setState(() {
//         //     _controller.reset();
//         //   });
//         // });
//       },
//       child: BlocSelector<BoardBloc, BoardState, ScoreState>(
//         selector: ((state) {
//           return ScoreState(state.score);
//         }),
//         builder: ((context, state) {
//           return Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 padding: const EdgeInsets.fromLTRB(60, 10, 10, 10),
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue.shade50),
//                 child: Text(state.score.toString(),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Color(0xff1c2550),
//                     )),
//               ),
//               Positioned(
//                 left: -6,
//                 top: -12,
//                 child: SizedBox(
//                   width: 60,
//                   height: 60,
//                   child: RiveAnimation.asset(
//                     BoxAnimations.blue,
//                     controllers: [_controller],
//                   ),
//                 ),
//               )
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

// class SpeedController extends OneShotAnimation {
//   final double speedMultiplier;
//   late Artboard _artboard;

//   SpeedController(
//     String animationName, {
//     double mix = 1,
//     this.speedMultiplier = 1,
//   }) : super(animationName, mix: mix, autoplay: false);

//   @override
//   void reset() {
//     if (instance == null || !instance!.keepGoing) {
//       isActive = false;
//     }
//     instance?.reset();
//     instance!.animation.apply(0, coreContext: _artboard as RuntimeArtboard);
//     isActive = false;
//   }

//   @override
//   void apply(RuntimeArtboard artboard, double elapsedSeconds) {
//     if (instance == null || !instance!.keepGoing) {
//       isActive = false;
//     }
//     instance!
//       ..animation.apply(instance!.time, coreContext: artboard, mix: mix)
//       ..advance(elapsedSeconds * speedMultiplier);
//   }

//   @override
//   bool init(RuntimeArtboard artboard) {
//     _artboard = artboard;
//     return super.init(artboard);
//   }
// }
