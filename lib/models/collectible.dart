import 'package:equatable/equatable.dart';

enum Collectibles { cherry }

class Collectible extends Equatable {
  const Collectible(this.type);

  final Collectibles type;

  @override
  List<Object> get props => [type];
}
