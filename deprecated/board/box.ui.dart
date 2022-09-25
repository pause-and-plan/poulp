import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:poulp/logic/board_bloc/entities/board.dart';
import 'package:poulp/logic/board_bloc/entities/board_gravitator.dart';
import 'package:poulp/logic/board_bloc/entities/box.dart';
import 'package:rive/rive.dart';

class BoxUI extends StatefulWidget {
  final Box box;
  final int index;

  const BoxUI({Key? key, required this.box, required this.index}) : super(key: key);

  @override
  State<BoxUI> createState() => _BoxUIState();
}

class _BoxUIState extends State<BoxUI> {
  // late AnimationController _animationController;
  // late GravitySimulation _gravitySimulation;

  @override
  void initState() {
    super.initState();
    // _gravitySimulation = GravitySimulation(
    //   1000.0, // acceleration
    //   widget.box.dy, // starting point
    //   widget.board.getLowerBound(widget.index), // end point
    //   0.0, // starting velocity
    // );
    // _animationController = AnimationController(vsync: this, upperBound: widget.board.getLowerBound(widget.index));
    // _animationController.addListener(() {
    //   setState(() {});
    // });
    // _animationController.animateWith(_gravitySimulation);
    // _animationController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     widget.box.position = Offset(widget.box.position.dx, _animationController.value);
    //     widget.box.offset = Offset.zero;
    //   }
    // });
  }

  @override
  void didUpdateWidget(BoxUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _animationController.duration = widget.box.duration;
  }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: widget.box.dx,
      top: widget.box.dy,
      duration: widget.box.duration,
      // duration: const Duration(milliseconds: 100),
      child: AnimatedScale(
        scale: widget.box.scale,
        duration: widget.box.duration,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: widget.box.color,
            // color: Colors.blue.shade50,
          ),
          // child: RiveAnimation.asset('assets/drop.riv'),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -6,
                top: -10,
                // child: Container(
                //   child: RiveAnimation.asset('assets/drop.riv'),
                //   height: 70,
                //   width: 70,
                // ),
                child: Image.asset(
                  'assets/drop.png',
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
