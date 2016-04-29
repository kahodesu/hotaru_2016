//////////////////////VARIABLES//////////////////////////////

byte[] tankBlob = new byte [90];
int numOfPixels; 
int remainingPixels;

//////////////////////FUNCTIONS//////////////////////////////

void tankColor(String colorName, int brightness, int levels) {

  numOfPixels= levels * 3 * 3;
  //--------------------------------------------------------------------
  if (colorName == "red") {
    for (int i=0; i<numOfPixels; i=i+3) {
      tankBlob[i] = byte(brightness);
      tankBlob[i+1] = byte(0);
      tankBlob[i+2] = byte(0);
    }
    //the rest is off
    for (int i = numOfPixels; i<90; i=i+3) {
      tankBlob[i] = byte(0);
      tankBlob[i+1] = byte(0);
      tankBlob[i+2] = byte(0);
    }
  }
  //--------------------------------------------------------------------
  else if (colorName == "blue") {
    //turn on LED color for as many levels
    //the first 3 for 3 neopixels per level, second 3 for r, g, b. 
    for (int i=0; i<numOfPixels; i=i+3) {
      tankBlob[i] = byte(0);
      tankBlob[i+1] = byte(0);
      tankBlob[i+2] = byte(brightness);
    }
    //the rest is off
    for (int i = numOfPixels; i<90; i=i+3) {
      tankBlob[i] = byte(0);
      tankBlob[i+1] = byte(0);
      tankBlob[i+2] = byte(0);
    }
  }
  //--------------------------------------------------------------------
  else if (colorName == "white") {
    //turn on LED color for as many levels
    //the first 3 for 3 neopixels per level, second 3 for r, g, b. 
    tankWipe();
    for (int i=0; i<numOfPixels; i=i+3) {
      tankBlob[i] = byte(brightness);
      tankBlob[i+1] = byte(brightness);
      tankBlob[i+2] = byte(brightness);
    }
    //the rest is off
    for (int i = numOfPixels; i<90; i=i+3) {
      tankBlob[i] = byte(0);
      tankBlob[i+1] = byte(0);
      tankBlob[i+2] = byte(0);
    }
  }
  //--------------------------------------------------------------------
  else if (colorName == "teal") {
    //turn on LED color for as many levels
    //the first 3 for 3 neopixels per level, second 3 for r, g, b. 
    // tankWipe();
    for (int i=0; i<numOfPixels; i=i+3) {
      tankBlob[i] = byte(brightness);
      tankBlob[i+1] = byte(brightness);
      tankBlob[i+2] = byte(0);
    }
    //the rest is off
    for (int i = numOfPixels; i<90; i=i+3) {
      tankBlob[i] = byte(0);
      tankBlob[i+1] = byte(0);
      tankBlob[i+2] = byte(0);
    }
  } else if (colorName == "flash") {
    if (flashTimer2.isFinished()==true) {
      tankWipe();
      //println("random");
      for (int i=0; i<numOfPixels; i=i+3) {
        if (int(random(1, 10))%3 ==0) {
          tankBlob[i] = byte(brightness);
          tankBlob[i+1] = byte(brightness);
          tankBlob[i+2] = byte(brightness);
        }
      }
      flashTimer2.start();
    }
  } else if (colorName == "fire") {
    if (fireTimer.isFinished()==true) {
      tankColor("red", brightness, levels);
      //println("random");
      for (int i=0; i<numOfPixels; i=i+3) {
        if (int(random(1, 10))%3 ==0) {
          tankBlob[i] = byte(brightness*.80);
          tankBlob[i+1] = byte(brightness*random(50)/ (float)100);
          tankBlob[i+2] = byte(0);
        }
      }
      fireTimer.start();
    }
  } 

  else if (colorName == "alarm") {

    if (alarmTimer.isFinished() == true) {
      alarmTimer.start();
      alarmRedOn = !alarmRedOn;
    }
    if (alarmRedOn == true) {
      tankColor("red", brightness, levels);
    } else {
      tankWipe();
    }
  }
}

void tankWipe() {
  for (int i = 0; i<tankBlob.length; i++) {
    tankBlob[i] = byte(0);
  }
  tankShow();
}