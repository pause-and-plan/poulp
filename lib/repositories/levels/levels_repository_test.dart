import 'dart:io';

import 'package:poulp/repositories/levels/levels_repository.dart';
import 'package:flutter_test/flutter_test.dart';

File defaultFile = File('./assets/levels/level_0.json');

void main() {
  test('Counter value should be incremented', () {
    final levels = LevelsRepository();

    levels.save(defaultFile);
  });
}
