enum Blockers { wrapper, block }

class Blocker {
  Blocker(this.type, {this.level = 0});

  Blockers type;
  int level;
}
