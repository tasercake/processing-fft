class Matrix {
  public byte rows;
  public byte columns;
  public int colorPreset;
  public int[][] rgb;
  public int matrixHeight;
  public final byte ledArray[][] = new byte[columns][rows];
  public int matrixWidth;
  public int cellMargin = 2;
  public float hueOffset = 0;
  public float rainbowFrequency = 1;
  private Cell[][] cellArray;
  private byte[][] pixPerCell;

  // Matrix object constructor
  Matrix(byte x, byte y, int temp_width, int temp_height, int temp_margin, byte[][] ledArray) {
    rows = y;
    columns = x;
    matrixHeight = temp_height;
    matrixWidth = temp_width;
    cellMargin = temp_margin;  
    pixPerCell = ledArray;
  }

  // Default constructor
  Matrix(byte x, byte y, byte[][] pixelCount) {
    rows = y;
    columns = x;
    matrixHeight = 32;
    matrixWidth = 32;
    cellMargin = 2;
    pixPerCell = pixelCount;
  }

  public void begin() {
    cellArray = new Cell[columns][rows];
    for (byte i = 0; i < columns; ++i) {
      for (byte j = 0; j < rows; ++j) {
        cellArray[i][j] = new Cell(j, i, pixPerCell[j][i]);
      }
    }
  }

  void RainbowColumns() {
    for (byte i = 0; i < columns; ++i) {
      for (byte j = 0; j < rows; ++j) {
        cellArray[i][j].hue = (hueOffset % 1) + (rainbowFrequency*i/columns);
        cellArray[i][j].sat = 1;
        cellArray[i][j].lum = 1;
      }
    }
  }

  void gradientHSL(HslCol col1, HslCol col2, float angle) { 
    double angleDouble = angle % 360;
    angleDouble = Math.toRadians(angleDouble);
    angle = (float)angleDouble;
    for (byte i = 0; i < columns; ++i) {
      for (byte j = 0; j < rows; ++j) {
        cellArray[i][j].hue = (sin(angle) * lerp(col1.hue, col2.hue, (((float)(columns/2 - (float)i))/((float)columns)))) + (cos(angle) * lerp(col1.hue, col2.hue, ((((float)rows/2 - (float)j))/((float)rows))));
        cellArray[i][j].sat = (sin(angle) * lerp(col1.sat, col2.sat, (((float)(columns/2 - (float)i))/((float)columns)))) + (cos(angle) * lerp(col1.sat, col2.sat, ((((float)rows/2 - (float)j))/((float)rows))));
        cellArray[i][j].lum = (sin(angle) * lerp(col1.lum, col2.lum, (((float)(columns/2 - (float)i))/((float)columns)))) + (cos(angle) * lerp(col1.lum, col2.lum, ((((float)rows/2 - (float)j))/((float)rows))));
      }
    }
  }

  void colorAll(HslCol col) {
    for (byte i = 0; i < columns; ++i) {
      for (byte j = 0; j < rows; ++j) {
        cellArray[i][j].hue = col.hue;
        cellArray[i][j].sat = col.sat;
        cellArray[i][j].lum = col.lum;
      }
    }
  }

  void audioBars() {
    for (int i = 0; i < columns; ++i) {
      float barHeight = rows*intensityArray[i];
      for (int j = 0; j < rows; ++j) {
        cellArray[i][j].sat = 1;
        cellArray[i][j].hue = 0;
        if (j < floor(barHeight)) {
          cellArray[i][rows-j-1].lum = 1;
        } else if (j == floor(barHeight)) {
          cellArray[i][rows-j-1].lum = barHeight % 1;
        } else {
          cellArray[i][rows-j-1].lum = 0;
        }
      }
    }
  }

  void update() {
    for (byte i = 0; i < columns; ++i) {
      for (byte j = 0; j < rows; ++j) {
        cellArray[i][j].update();
      }
    }
  }

  void drawMatrixTris() {
    for (byte i = 0; i < columns; ++i) {
      for (byte j = 0; j < rows; ++j) {

        fill(cellArray[i][j].rgb);
        stroke(0);
        strokeWeight(cellMargin);
        if (j % 2 == 0) {
          triangle(
            i * matrixWidth/columns, 
            j * matrixHeight/rows, 
            (i+1) * matrixWidth/columns, 
            j * matrixHeight/rows, 
            i * matrixWidth/columns, 
            2*((j/2)+1) * matrixHeight/rows);
        } else {
          triangle(
            (i+1) * matrixWidth/columns, 
            2*floor((j/2)) * matrixHeight/rows, 
            i * matrixWidth/columns, 
            2*((j+1)/2) * matrixHeight/rows, 
            (i+1) * matrixWidth/columns, 
            2*((j+1)/2) * matrixHeight/rows);
        }
      }
    }
  }

  void drawmatrixRect() {
    noStroke();
    for (byte i = 0; i < columns; ++i) {
      for (byte j = 0; j < rows; ++j) {
        fill(cellArray[i][j].rgb);
        rect(i * (matrixWidth/columns + cellMargin) + cellMargin, j * (matrixHeight/rows + cellMargin) + cellMargin, matrixWidth/columns, matrixHeight/rows);
      }
    }
  }
}

class HslCol {
  float hue;
  float sat;
  float lum;

  HslCol() {
  }

  HslCol(float h, float s, float l) {
    hue = h;
    sat = s;
    lum = l;
  }
}

void updateMatrix() {
  matrix.update();
}

void audioBars() {
  matrix.audioBars();
}