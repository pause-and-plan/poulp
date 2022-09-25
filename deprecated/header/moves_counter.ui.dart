import 'package:flutter/material.dart';

class MovesCounterUI extends StatelessWidget {
  const MovesCounterUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blue.shade50),
          child: Row(children: const [
            Icon(
              Icons.swipe,
              size: 40,
              color: Color(0xff1c2550),
            ),
            SizedBox(width: 10),
            Text('30',
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xff1c2550),
                )),
          ]))
    ]);
  }
}


        // SizedBox(
        //   height: 100,
        //   width: 100,
        //   child: FittedBox(
        //     child: FloatingActionButton.extended(
        //       onPressed: () => {},
        //       backgroundColor: Colors.white,
        //       icon: const Icon(
        //         Icons.swap_vert_outlined,
        //         color: Color(0xff1c2550),
        //       ),
        //       label: const Text(
        //         '30',
        //         style: TextStyle(
        //           fontSize: 40,
        //           color: Color(0xff1c2550),
        //         ),
        //       ),
        //     ),
        //   ),
        // )