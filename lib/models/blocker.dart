import 'package:flutter/material.dart';

enum Blockers { wrapper, block }

class Blocker {
  Blocker(this.type, {this.level = 0});

  Blocker clone() => Blocker(type, level: level);

  Blockers type;
  int level;
}

extension BlockerColor on Blocker {
  Color color() {
    switch (type) {
      case Blockers.wrapper:
        return Colors.pink;
      case Blockers.block:
        return Colors.grey;
    }
  }
}
