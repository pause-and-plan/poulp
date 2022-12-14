import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:poulp/repositories/levels/levels_repository.dart';
import 'package:poulp/models/game.dart';
import 'package:poulp/models/tiles.dart';

File level0 = File('./assets/levels/level_0.json');
File level1 = File('./assets/levels/level_1.json');

void main() {
  test('Initialize game', () {
    final levels = LevelsRepository();
    final level = levels.get(level1);
    final game = Game.fromLevel(level);
    // game.tiles.debug();
  });
}
