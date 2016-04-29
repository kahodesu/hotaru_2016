//TODO
// add new defense mechanic for tank person too. 
// think of analog gameplay
// feedback for successfully defending - animation on lights? 
// health points, deterioting when defending badly 
// end state -- staying alive for whole game 
// maybe as long as you shoot the attacks remain manageable
// on GUI: be able to adjust win state 


int minHealth = 20;
int minSuccess = 3;
int hurt = 0; //0 = default, 1 = a little hurt, 2 = kinda hurt, 3= hurt, 4 = pretty hurt. 

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
boolean tankDucked = false;
int lastTankIMUz;
boolean alarmRedOn = false;
boolean tankOnce = false;
int health = 0;
int overallHealth = 100;
int totalHealth = 0;
int success = 0;
int counterDepleteFast =0;



PImage img, img2, logo;

void setup() {
  size(600, 600);
  resetEverything();
}
void draw() {
checkHealth();
  //println("  prox: " + proxVal);
  /////////////////////GUI shit///////////////////
  if (attractOn == true) {
    
    image(img, 0, 0);
    gauntletColor("flash", 150, 28);
    tankColor("flash", 150, 10);
    tankShow();
    gauntletShow();
  }
  else {
    background(225);
  }
   image(logo, 0, 0);
  drawLine();
  drawAttacks();
  //println(health + "---"+ success);
  //println("state: " + state +"  tankLevel: "+tankLevel+"  proxVal: "+ proxVal +"  handsHolding: " + handsHolding);
  //println();



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

    checkTank();
    depleteTank();

    ////////////GAUNTLET STUFF/////////////

    if (warning.isPlaying()) {

      tankColor("alarm", 255, 10);
      tankShow();
      gauntletColor("alarm", 255, 28);
      gauntletShow();
      if (gauntletIMUx<40 && gauntletIMUx>-10 && gauntletIMUy<0 && gauntletIMUz<0) {
        health++;
        tankDuckCheck();
      }
    } else {
      if (tankDucked == true) {
        overallHealth = overallHealth+ health;
        tankDucked = false;
        tankOnce = false;
        health =0;
      }
      gauntletColor("white", 255, gauntletLevel);
      gauntletShow();
      tankColor("white", 255, tankLevel);
      tankShow();
    }


    if (tankLevel >0 && handsHolding == true && gauntletIMUx<0 && gauntletIMUz<0) {
      depleteFast();

      if (!power.isPlaying()) {
        power.rewind();
        power.play();
      }
      if (chargeGauntletTimer.isFinished()) {
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
    if (gauntletLevel >25 && handsHolding == false && gauntletIMUx > 70  && gauntletIMUx<100 && gauntletIMUy<0 && gauntletIMUz <0) {
      if (shootOn == false ) {
        shootOn = true;
        power.pause();
        power.rewind();

        gauntletWipe();
        delay(500);
        shoot.trigger();
        success++;
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
    if (overallHealth>500) {
      gauntletColor("flash", 255, 28);
      gauntletShow();
      tankColor("flash", 255, 10);
      tankShow();
    } else {
      gauntletColor("fire", 100, 28);
      gauntletShow();
      tankColor("fire", 100, 10);
      tankShow();
    }
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
  



//  println(sweetSpot);
  if (proxVal >50 && proxVal <80) {

    sweetSpot = true;
  } else {
    sweetSpot = false;
  }
  if (sweetSpot == true && lastSweetSpot == true) {
    sweetSpotCounter++;
  }
  if (sweetSpotCounter >10 && sweetSpot == false && lastSweetSpot == false) {
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

void depleteFast () {
  counterDepleteFast++;
  if (counterDepleteFast%50 ==0) {
    tankLevel --;
  }
}

void resetEverything() {
  setupGUI();
  setupSound();
  setupOSC();
  setUpTimer();
  state = REST;
  gauntletWipe();
  tankWipe();
  ELOff();
  success=0;
  health = 0;
  hurt = 0;
  img = loadImage("attractmode.png");
  img2 = loadImage("submitfirst.png");
logo = loadImage("logo.png");
  overallHealth = 100;
  totalHealth = overallHealth;
tankDucked = false;
}

void tankDuckCheck(){
if ((tankIMUz-lastTankIMUz)>10 && tankOnce == false){
  tankDucked = true;
  println("*********DUCKED!!********");
  tankOnce = true;
}
 lastTankIMUz = tankIMUz;
}