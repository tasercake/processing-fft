void keyPressed() {
  if (keyCode == UP) {
    scale++;
  } else if (keyCode == DOWN) {
    scale--;
  } else {
  }
}

void drawSpectrum() {
  for (int i = 0; i < columns; i++) {
    stroke(255);
    line((i+0.25)*(width/columns), height, (i+0.25)*(width/columns), height*(1 - intensityArray[i]));
    stroke(0);
    line((i+0.25)*(width/columns), height*(1 - intensityArray[i]), (i+0.25)*(width/columns), 0);
  }
}