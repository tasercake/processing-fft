void setPixelHue(byte x, byte y, int z) {
  ledHue[x][y] = (byte)z;
}

void setPixelSat(byte x, byte y, int z) {
  ledSat[x][y] = (byte)z;
}

void setpixelLum(byte x, byte y, int z) {
  ledLum[x][y] = (byte)z;
}

void barsToPixelLum() {
  for (byte col = 0; col < columns; ++col) {
    float barHeight = rows*intensityArray[col];
    for (byte row = 0; row < rows; ++row) {
      if(row < floor(barHeight)) {
        setpixelLum(col,row,255);
      }
      else if(row == floor(barHeight)) {
        setpixelLum(col,row,(int)(255*(barHeight%1)));
      }
      else {
        setpixelLum(col,row,0);
      }
    }
  }
}