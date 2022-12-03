import 'dart:convert';
import 'dart:io';

import 'package:poulp/repositories/levels/level.dart';

final levelsFiles = [
  File('./assets/levels/level_1.json'),
  File('./assets/levels/level_2.json'),
  File('./assets/levels/level_3.json'),
  File('./assets/levels/level_4.json'),
];

class LevelsRepository {
  save(File file) {
    file.writeAsStringSync(jsonEncode(Level().toJson()));
  }

  Level get(File file) {
    return Level.fromJson(jsonDecode(file.readAsStringSync()));
  }

  Level getNextIncompleteLevel() {
    return Level.fromJson(jsonDecode(levelsFiles[0].readAsStringSync()));
  }
}
