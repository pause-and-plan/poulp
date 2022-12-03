enum Collectibles { cherry }

class Collectible {
  Collectible(this.type);

  Collectible clone() => Collectible(type);

  Collectibles type;
}
