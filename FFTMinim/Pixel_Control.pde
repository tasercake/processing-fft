void setPixelHue(byte x, byte y, float z) {
  ledHue[x][y] = (float)z;
}

void setPixelSat(byte x, byte y, float z) {
  ledSat[x][y] = (float)z;
}

void setpixelLum(byte x, byte y, float z) {
  ledLum[x][y] = (float)z;
}

// set matrix to bar height
void setLum_barHeight() {
  for (byte x = 0; x < columns; ++x) {
    float barHeight = rows*intensityArray[x];
    for (byte y = 0; y < rows; ++y) {
      if (y < floor(barHeight)) {
        setpixelLum(x, y, 1);
      } else if (y == floor(barHeight)) {
        setpixelLum(x, y, (barHeight%1));
      } else {
        setpixelLum(x, y, 0);
      }
    }
  }
}

// set matrix to 'rainbow' horizontally
void setColor_spectrum() {
  for (byte x = 0; x < columns; ++x) {
    for (byte y = 0; y < rows; ++y) {
      setPixelHue(x, y, x/columns);
      setPixelSat(x, y, 1);
    }
  }
}

// converts one pixel from HSL to RGB
int pixel_HSVtoRGB(byte x, byte y) { 
  if (x >= columns || y >= rows || x < 0 || y < 0) { // out of bounds handler
    print("Pixel coordinates out of bounds");
    return 0;
  } else {
    return(Color.HSBtoRGB(ledHue[x][y], ledSat[x][y], ledLum[x][y]));
  }
}

// updates the entire RGB matrix
void update_ledRGB() { 
  for (byte x = 0; x < columns; ++x) {
    for (byte y = 0; y < rows; ++y) {
      ledRGB[x][y] = pixel_HSVtoRGB(x, y);
    }
  }
}