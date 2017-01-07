void doFFT() {
  fft.window(new HammingWindow());
  fft.forward(input.mix);
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


// NOT IN USE
class FFTobj {
  int mindb = 12;
  float dbRange = 2.5;
  int[] frequencyWindow;
  float[] eq;
  float[] intensityArray = new float [columns];
  Minim minim;
  FFT fft;
  AudioInput input;
  WMA wma;

  FFTobj(int size, int smpRate, int freqWind[], float eqArray[], int minimum, float scale) {
    minim = new Minim(this);
    input = minim.getLineIn(Minim.STEREO, size, smpRate);
    fft = new FFT(size, smpRate);
    wma = new WMA(30, this.intensityArray);

    frequencyWindow = freqWind.clone();
    eq = eqArray.clone();
    mindb = minimum;
    dbRange = 1/scale;
  }

  void doFFT() {
    fft.window(new HammingWindow());
    fft.forward(input.mix);
    getIntensityArray();
  }

  private void getIntensityArray() {
    for (int i = 0; i < columns; ++i) {
      float intensity = (log(fft.calcAvg(frequencyWindow[i], frequencyWindow[i+1])));
      intensity *= eq[i];
      intensity -= mindb;
      intensity /= dbRange;
      intensity = intensity < 0.0 ? 0.0 : intensity;
      intensity = intensity > 1.0 ? 1.0 : intensity;
      intensityArray[i] = intensity;
    }
  }
}

//   NOT IN USE
class WMA {
  private int dejitter;
  private float avgArray[][] = new float[columns][dejitter];
  private float oldArray[][] = new float[columns][dejitter];
  private float source[];
  private int counter;
  private boolean flag = false;

  WMA(int amt, float[] srcArray) {
    dejitter = amt;
    source = srcArray.clone();
  }

  void movingAverage() {
    for (int i = 0; i < columns; ++i) {
      for (int j = 0; j < dejitter; ++j) {
        avgArray[i][j] = source[i];
      }
    }
  }
}