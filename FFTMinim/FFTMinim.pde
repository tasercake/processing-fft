import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;
Minim minim;
AudioInput input;
FFT fft;
Serial mySerial;

final int columns = 20;
final int fftsize = 256;
final int samplerate = 16384;
final float[] frequencyWindow = {64, 76, 94, 118, 150, 185, 225, 295, 360, 420, 490, 580, 770, 880, 980, 1180, 1650, 2500, 4700, 6800, 8192};
//final float[] frequencyWindow = {64,82,104,133,169,215,274,350,446,568,724,923,1176,1499,1911,2435,3104,3956,5043,6427,8192};
//final float[] EQARRAY = {-2.2, -2, -1.7, -1.3, -1, -0.85, -0.4, 0.3, 0.4, 0.8, 0.85, 1.9, 1.9, 2.0, 2.1, 2.2, 2.35, 2.4, 2.45, 2.8};
final int mindb = 10;
final int maxdb = 75;

float[] intensityArray = new float [columns];

void setup()
{
  printArray(Serial.list());
  mySerial = new Serial(this, Serial.list()[0], 9600);

  size(512, 200);
  stroke(255);

  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, fftsize, samplerate);
  fft = new FFT(fftsize, samplerate);
}

void draw()
{
  background(0);
  fft.window(new HammingWindow());
  fft.forward(input.mix);
  //fft.logAverages(32,2);

  getIntensityArray();
  if (mySerial.available() > 0) {
    if (mySerial.readChar() == '\n') {  //request received from arduino
      sendIntensityArray();             //send data to arduino
    }
  }

  for (int i = 0; i < intensityArray.length; i++) {
    line((i+0.5)*(width/20), height, (i+0.5)*(width/20), height - 200*intensityArray[i]);
    //line(i,height,i,height - fft.getBand(i)*4);
  }
}

void getIntensityArray() {
  for (int i = 0; i < columns; ++i) {
    float intensity = 16*(log(fft.calcAvg(frequencyWindow[i], frequencyWindow[i+1])));
    intensity -= mindb;
    intensity = intensity < 0.0 ? 0.0 : intensity;
    intensity /= (maxdb - mindb);
    intensity = intensity > 1.0 ? 1.0 : intensity;
    intensityArray[i] = intensity;
  }
}

void sendIntensityArray() {
  //String intensitystring;
  mySerial.write('<');
  for (int i = 0; i < columns; ++i) {
    //intensitystring = String.format("%03d", intensityArray[i]);  //padded with 0s if necessary
    mySerial.write(byte(intensityArray[i]));
    //print(intensitystring);
  }
  mySerial.write('>');
}