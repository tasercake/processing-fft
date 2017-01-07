class Cell {
  float hue;
  float sat;
  float lum;
  int rgb;
  int red;
  int green;
  int blue;
  byte numPixels;
  byte x;
  byte y;

  Cell(byte col, byte row, byte numpix) {
    x = col;
    y = row;
    numPixels = numpix;
    rgb = 0;
  }

  void update() {
    rgb = Color.HSBtoRGB(hue, sat, lum);
    red = (rgb >> 16) & 0xFF;
    green = (rgb >> 8) & 0xFF;
    blue = rgb & 0xFF;
  }
}

class HSL {
  int hue;
  int sat;
  int lum;
}