import 'dart:convert';
import 'dart:io';

import 'package:poulp/repositories/levels/level.dart';

class LevelsRepository {
  save(File file) {
    file.writeAsStringSync(jsonEncode(Level().toJson()));
  }

  Level get(File file) {
    return Level.fromJson(jsonDecode(file.readAsStringSync()));
  }
}
