void initSerial() {
  printArray(Serial.list());
  mySerial = new Serial(this, Serial.list()[0], 115200);
}