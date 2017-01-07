import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;
import java.awt.Color;

Minim minim;
AudioInput input;
FFT fft;

Serial mySerial;
Matrix matrix;

// Can't touch this
final int fftsize = 512;
final int samplerate = 24000;
final byte columns = 20;
final byte rows = 14;
final float[] frequencyWindow = {32, 64, 100, 130, 150, 180, 240, 280, 360, 480, 560, 720, 960, 1020, 1440, 1920, 2040, 3000, 5600, 9000, 12000};
final byte[][] ledArray = {
  {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 4}, {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 4, 7}, 
  {3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 2, 2, 3, 3, 4, 4}, {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 4, 7}, 
  {2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5}, {3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5}, 
  {4, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 4, 5}, {5, 4, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 5}, 
  {5, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4}, {5, 4, 3, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4}, 
  {5, 4, 3, 3, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3}, {6, 4, 3, 2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 3, 2, 3, 3, 3, 4}, 
  {6, 3, 2, 2, 2, 2, 2, 2, 3, 3, 3, 2, 2, 2, 2, 3, 3, 3, 3, 4}, {3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}};
float[] intensityArray = new float [columns];

// Edit these as needed
final float[] EQARRAY = {-1, -2, -3, -4, -4, -0.85, -0.5, 2, 9, 12, 14, 15, 19, 19, 22, 22.5, 23, 24, 25, 26};
final float[] EQARRAY2 ={0.55, 0.6, 0.6, 0.6, 0.57, 0.63, 0.73, 0.78, 0.87, 0.89, 0.92, 0.94, 0.97, 0.89, 1.08, 1, 1.5, 1.7, 2, 2.9};
final int mindb = 18;
final int dbRange = 66;
int scale = 26;

void setup() {
  //initSerial();
  size(1280, 224, P2D);
  stroke(255);
  background(0);
  
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, fftsize, samplerate);
  fft = new FFT(fftsize, samplerate);
  
  matrix = new Matrix(columns, rows, 1280, 224, 4, ledArray);
  matrix.begin();
}

void draw() {
  thread("doFFT");
  thread("getIntensityArray");
  thread("audioBars");
  thread("updateMatrix");
  //thread("matrix.sendRGB");
  matrix.drawMatrixTris();
}