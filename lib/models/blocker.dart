import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Blockers { wrapper, block }

class Blocker extends Equatable {
  const Blocker(this.type, {this.level = 0});

  final Blockers type;
  final int level;

  @override
  List<Object> get props => [type, level];
}

extension BlockerColor on Blocker {
  Gradient gradient() {
    switch (type) {
      case Blockers.wrapper:
        return const LinearGradient(colors: [Colors.pink, Colors.pink]);
      case Blockers.block:
        return const LinearGradient(colors: [Colors.grey, Colors.grey]);
    }
  }
}
