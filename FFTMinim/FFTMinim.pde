import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;
import java.awt.Color;
Minim minim;
AudioInput input;
FFT fft;
Serial mySerial;

//FIXED
final int fftsize = 512;
final int samplerate = 24000;
final int columns = 20;
final int rows = 14;
//final float[] frequencyWindow = {64, 84, 111, 146, 192, 253, 334, 440, 580, 760, 880, 990, 1100, 1400, 1900, 2800, 3900, 5600, 7500, 9900, 12000};
final float[] frequencyWindow = {32, 64, 100, 130, 150, 180, 240, 280, 360, 480, 560, 720, 960, 1020, 1440, 1920, 2040, 3000, 5600, 9000, 12000};
final int[][] ledArray = {
  {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 4}, {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 4, 7}, 
  {3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 2, 2, 3, 3, 4, 4}, {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 4, 7}, 
  {2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5}, {3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5}, 
  {4, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 4, 5}, {5, 4, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 5}, 
  {5, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4}, {5, 4, 3, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4}, 
  {5, 4, 3, 3, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3}, {6, 4, 3, 2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 3, 2, 3, 3, 3, 4}, 
  {6, 3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 3, 4}, {3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}};

float[][] ledHue = new float[columns][rows];
float[][] ledSat = new float[columns][rows];
float[][] ledLum = new float[columns][rows];
int [][] ledRGB = new int[columns][rows];
float[] spectrum = new float[fftsize];
float[] intensityArray = new float [columns];

//EDIT
final float[] EQARRAY = {-1, -2, -3, -4, -4, -0.85, -0.5, 2, 9, 12, 14, 15, 19, 19, 22, 22.5, 23, 24, 25, 26};
final float[] EQARRAY2 ={0.9, 0.6, 0.51, 0.5, 0.52, 0.55, 0.58, 0.67, 0.76, 0.76, 0.78, 0.88, 0.95, 0.89, 1.08, 1, 1.5, 1.7, 2, 3.7};
final int mindb = 5;
final int dbRange = 128;
int scale = 45;

//TIMERS
long timer1 = 0;
long timer2 = 0;

void setup() {
  //initSerial();
  size(1024, 400);
  stroke(255);
  background(0);
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, fftsize, samplerate);
  fft = new FFT(fftsize, samplerate);
  timer1 = millis();

  thread("setColor_spectrum");
}

void draw() {
  thread("doFFT");
  thread("setLum_barHeight");
  thread("update_ledRGB");
  thread("sendRGB");
  if (millis() - timer1 >= 10) {
    drawSpectrum();
    timer1 = millis();
  }
}