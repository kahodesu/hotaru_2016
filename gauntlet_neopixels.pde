//////////////////////VARIABLES//////////////////

byte[] gauntletBlob = new byte [84];

//////////////////////FUNCTIONS//////////////////////////////

void gauntletColor(String colorName, int brightness, int neopixels) {
  //--------------------------------------------------------------------
  if (colorName == "red") {
    //turn on LED color for as many levels
    //the first 3 for 3 neopixels per level, second 3 for r, g, b. 
    //   gauntletWipe();
    for (int i=0; i<neopixels * 3; i=i+3) {
      gauntletBlob[i] = byte(brightness);
      gauntletBlob[i+1] = byte(0);
      gauntletBlob[i+2] = byte(0);
    }
    for (int i = neopixels * 3; i<84; i=i+3) {
      gauntletBlob[i] = byte(0);
      gauntletBlob[i+1] = byte(0);
      gauntletBlob[i+2] = byte(0);
    }
  gauntletShow();
  }
  //--------------------------------------------------------------------
  else if (colorName == "blue") {
    //turn on LED color for as many levels
    //the first 3 for 3 neopixels per level, second 3 for r, g, b. 
    for (int i=0; i<neopixels * 3; i=i+3) {
      gauntletBlob[i] = byte(0);
      gauntletBlob[i+1] = byte(0);
      gauntletBlob[i+2] = byte(brightness);
    }
    for (int i = neopixels * 3; i<84; i=i+3) {
      gauntletBlob[i] = byte(0);
      gauntletBlob[i+1] = byte(0);
      gauntletBlob[i+2] = byte(0);
    }
  gauntletShow();
  }
  //--------------------------------------------------------------------
  else if (colorName == "white") {
    //turn on LED color for as many levels
    //the first 3 for 3 neopixels per level, second 3 for r, g, b. 
    // gauntletWipe();
    for (int i=0; i<neopixels * 3; i=i+3) {
      gauntletBlob[i] = byte(brightness);
      gauntletBlob[i+1] = byte(brightness);
      gauntletBlob[i+2] = byte(brightness);
    }

    for (int i = neopixels * 3; i<84; i=i+3) {
      gauntletBlob[i] = byte(0);
      gauntletBlob[i+1] = byte(0);
      gauntletBlob[i+2] = byte(0);
    }
  gauntletShow();
  }
  //--------------------------------------------------------------------
  else if (colorName == "teal") {
    //turn on LED color for as many levels
    //the first 3 for 3 neopixels per level, second 3 for r, g, b. 

    for (int i=0; i<neopixels * 3; i=i+3) {
      gauntletBlob[i] = byte(brightness);
      gauntletBlob[i+1] = byte(brightness);
      gauntletBlob[i+2] = byte(0);
    }
    for (int i = neopixels * 3; i<84; i=i+3) {
      gauntletBlob[i] = byte(0);
      gauntletBlob[i+1] = byte(0);
      gauntletBlob[i+2] = byte(0);
    }
  gauntletShow();
  } 

  else if (colorName == "flash") {
    if (flashTimer.isFinished()==true) {
     gauntletWipe();
      //println("random");
      for (int i=0; i<neopixels * 3; i=i+3) {
        if (int(random(1, 10))%3 ==0) {
          gauntletBlob[i] = byte(brightness);
          gauntletBlob[i+1] = byte(brightness);
          gauntletBlob[i+2] = byte(brightness);
        }
      }
      flashTimer.start();
    }
  gauntletShow();
  }

  else if (colorName == "fire") {
    if (fireTimer2.isFinished()==true) {
      for (int i=0; i<neopixels * 3; i=i+3) {
      gauntletBlob[i] = byte(brightness);
      gauntletBlob[i+1] = byte(0);
      gauntletBlob[i+2] = byte(0);
    }
      //println("random");
      for (int i=0; i<neopixels * 3; i=i+3) {
        if (int(random(1, 10))%3 ==0) {
          gauntletBlob[i] = byte(brightness*.80);
          gauntletBlob[i+1] = byte(brightness*random(50)/ (float)100);
          gauntletBlob[i+2] = byte(0);
        }
      }
      fireTimer2.start();
    }
  gauntletShow();
  }

else if (colorName == "alarm") {
    if (alarmRedOn == true) {
      gauntletColor("red", brightness, neopixels);
    } else {
      gauntletWipe();
    }
  }
}

void gauntletWipe() {
  for (int i = 0; i<gauntletBlob.length; i++) {
    gauntletBlob[i] = byte(0);
  }
 gauntletShow();
}