import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:poulp/repositories/levels/level.dart';

final levelsPath = [
  'assets/levels/level_1.json',
  'assets/levels/level_2.json',
];

class LevelsRepository {
  save(File file) {
    file.writeAsStringSync(jsonEncode(Level().toJson()));
  }

  Level get(File file) {
    return Level.fromJson(jsonDecode(file.readAsStringSync()));
  }

  Future<Level> getNextIncompleteLevel() async {
    String encoded = await rootBundle.loadString(levelsPath[0]);
    return Level.fromJson(jsonDecode(encoded));
  }
}
