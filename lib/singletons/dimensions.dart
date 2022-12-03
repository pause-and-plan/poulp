import 'dart:ui';

class Dimensions {
  int rows = 9;
  int cols = 9;
  int tileMargin = 2;
  int tileWidth = 40;
  int tileHeight = 44;
  double gridPadding = 2;
  double tilePositionX(int x) => x * (tileWidth + tileMargin).toDouble();
  double tilePositionY(int y) => y * (tileHeight + tileMargin).toDouble();
  Offset tilePosition(int x, int y) => Offset(tilePositionX(x), tilePositionY(y));
  Size get tileSize => Size(tileWidth.toDouble(), tileHeight.toDouble());
  double get gridWidth => ((tileWidth * cols) + (tileMargin * (cols - 1)) + gridPadding * 2).toDouble();
  double get gridHeight => ((tileHeight * rows) + (tileMargin * (rows - 1)) + gridPadding * 2).toDouble();
}

Dimensions dimensions = Dimensions();
