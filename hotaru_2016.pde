int state; //REST
int REST = 0;
int GAME = 1;
int GAMEOVER = 2;

int tankLevel = 10;
int gauntletLevel = 0;
int sweetSpotCounter =0;
int proxVal = 0;
boolean shootOn = false;
boolean sweetSpot = false;
boolean lastSweetSpot = false;
void setup() {
  size(600, 600);
  setupGUI();
  setupSound();
  setupOSC();
  setUpTimer();

  state = REST;
  gauntletWipe();
  tankWipe();
}
void draw() {
println("  prox: " + proxVal);
  /////////////////////GUI shit///////////////////
  background(255);
  drawLine();
  drawAttacks();

//  println("state: " + state +"  tankLevel: "+tankLevel+"  proxVal: "+ proxVal);
//print("  state: " + state);

   //gauntletColor("flash", 255, 28);
   //gauntletShow();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (state == REST) {
    gameOverSong.pause();
    gameSong.pause();
    if (!restSong.isPlaying()) {
      restSong.loop();
    }
    drawCursor();
  } 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  else if (state == GAME) {
    restSong.pause();
    gameOverSong.pause();
    drawCursor();
    checkAttack();

    if (!gameSong.isPlaying()&& pauseOn == false) {
      gameSong.loop();
    }

    ////////////TANK STUFF/////////////
    tankColor("white", 255, tankLevel);
    tankShow();
    checkTank();
    depleteTank();

    ////////////GAUNTLET STUFF/////////////
    gauntletColor("white", 255, gauntletLevel);
    gauntletShow();

    
    if (tankLevel >5 && handsHolding == true && gauntletIMUx <0 && gauntletIMUy<0 && gauntletIMUz<0) {
      
if (!power.isPlaying()) {
    power.rewind();
    power.play();
  }
if(chargeGauntletTimer.isFinished()){
        gauntletLevel ++;
chargeGauntletTimer.start();
}
        if (gauntletLevel > 28) {
          gauntletLevel = 28;
        }
        if (gauntletLevel < 0) {
          gauntletLevel = 0;
        }
      
    }
    if (gauntletLevel >25 && gauntletIMUx > 70  && gauntletIMUx<100 && gauntletIMUy<0 && gauntletIMUz <0)  {
      if (shootOn == false ) {
          shootOn = true;
        power.pause();
      power.rewind();
    
      gauntletWipe();
      delay(500);
             shoot.trigger();
           gauntletColor("white", 255, 28);
        gauntletShow();
           delay(1000); 
       gauntletLevel =0;
      shootOn = false;
    

      }
    }
    

    //println(handsHolding);//FOR DEBUG
  } 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  else if (state == GAMEOVER) {
gameSong.pause();
restSong.pause();
    gauntletColor("flash", 255, 28);
    gauntletShow();
    tankColor("flash", 255, 10);
    tankShow();
    if (!gameOverSong.isPlaying()) {
      gameOverSong.loop();
    }
    if (gameOverTimer.isFinished()) {
      state=0;
      pressReset();
      currentTime = 0;
 gauntletWipe();
  tankWipe();
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



void checkTank() {
  println(sweetSpot);
  if (proxVal >50 && proxVal <80) {
  
    sweetSpot = true;
   
  }
  else {
    sweetSpot = false;
   

  }
  if (sweetSpot == true && lastSweetSpot == true) {
    sweetSpotCounter++;  

  

  }
  if (sweetSpotCounter >15 && sweetSpot == false && lastSweetSpot == false) {
    tankLevel++;
    ELOn();
    if (!charge.isPlaying()) {
    charge.rewind();
charge.play();
  }
    sweetSpotCounter =0;
    if (tankLevel >10) {
      tankLevel = 10;
    }
  }
 

  lastSweetSpot = sweetSpot;
}

void depleteTank() {
  if (depleteTankTimer.isFinished()) {
    tankLevel --;
    ELOff();
    if (tankLevel <0) {
      tankLevel = 0;
    }
    depleteTankTimer.start();
  }
}