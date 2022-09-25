import 'package:flutter/material.dart';

class RestartUI extends StatelessWidget {
  const RestartUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: FittedBox(
        child: FloatingActionButton.small(
          onPressed: () => {},
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.restart_alt_outlined,
            color: Color(0xff1c2550),
          ),
        ),
      ),
    );
  }
}

// class RestartUI extends StatelessWidget {
//   const Restart({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.25),
//             blurRadius: 4,
//             offset: const Offset(1, 2),
//           )
//         ],
//       ),
//       child: IconButton(
//         onPressed: () => {},
//         icon: const Icon(Icons.restart_alt_outlined),
//       ),
//     );
//   }
// }
