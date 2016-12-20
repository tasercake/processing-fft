void doFFT() {
  //fft.window(new HannWindow());    
  fft.window(new HannWindow());
  fft.forward(input.mix);
  thread("getIntensityArray");
}

void getIntensityArray() {
  for (int i = 0; i < columns; ++i) {
    float intensity = scale*(log(fft.calcAvg(frequencyWindow[i], frequencyWindow[i+1])));
    //intensity += EQARRAY[i];
    intensity *= EQARRAY2[i];
    intensity -= mindb;
    intensity /= dbRange;
    intensity = intensity < 0.0 ? 0.0 : intensity;
    intensity = intensity > 1.0 ? 1.0 : intensity;
    intensityArray[i] = intensity;
  }
}