enum Blockers { wrapper, block }

class Blocker {
  Blocker(this.type, {this.level = 0});

  Blocker clone() => Blocker(type, level: level);

  Blockers type;
  int level;
}
