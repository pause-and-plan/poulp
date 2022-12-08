import 'dart:math';

class RandomGenerator {
  late Random random;

  init(int seed) {
    random = Random(seed);
  }

  nextInt(int max) => random.nextInt(max);
}

RandomGenerator randomProvider = RandomGenerator();
