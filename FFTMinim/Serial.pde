void initSerial() {
  printArray(Serial.list());
  mySerial = new Serial(this, Serial.list()[0], 115200);
}

void sendRGB() {
  for (byte x = 0; x < columns; ++x) {
    for (byte y = 0; y < rows; ++y) {
      if (mySerial.available() == 0);
      else if (mySerial.available() > 0) {
        if (mySerial.read() == '\n' || mySerial.read() == '\r') {
          mySerial.write(ledRGB[x][y]);
        }
      }
    }
  }
  mySerial.write('\n');
}