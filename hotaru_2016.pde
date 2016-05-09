//TODO
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


int lastTankIMUz;
boolean alarmRedOn = false;
boolean tankDuckOnce = false;
float health = 0;
int success = 0;
int counterDepleteFast =0;



PImage img, img2, logo;

void setup() {
  size(600, 600);
  setupSound();
  setupGUI();
    setupOSC();
  resetEverything();
}


void draw() {
 checkHealth();
  //tankDuckCheck();

  //println("  prox: " + proxVal);
  /////////////////////ATTRACT MODE SHIT///////////////////
  if (attractOn) {
    gameOn = false;
    image(img, 0, 0);
    gauntletColor("flash", 150, 28);
    tankColor("flash", 150, 10);
  }
  
  else {
    background(225);
  }
   
  //ALWAYS DRAW THE LOGO, LINE AND ATTACKS IF THERE ARE ANY
  image(logo, 0, 0);
  drawLine();
  drawAttacks();

  
println("state: " + state +"  tankLevel: "+tankLevel+"  proxVal: "+ proxVal +"  handsHolding: " + handsHolding);
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
   if (health <=0 ) {
         gameOverTimer.start();
          state = GAMEOVER;
        }
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

    ////////////ATTACK STUFF/////////////

    if (warning.isPlaying()) {
      tankDuckCheck();
      if ( gauntletIMUy<-40 && gauntletIMUy>-70 && gauntletIMUz<-50 &&gauntletIMUz>-90) {
        health= health +.25; 
         tankColor("teal", 255, 10);
          gauntletColor("teal", 255, 28); 
      } 
      else {
        tankColor("alarm", 255, 10);
        gauntletColor("alarm", 255, 28);
      }
    } 

    else {
      if (tankDuckOnce == true) {
        tankDuckOnce = false;
        health = health +5;
      
      }
      gauntletColor("white", 255, gauntletLevel);
      tankColor("white", 255, tankLevel);
    }

    ////////////CHARGING STUFF/////////////
  
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

    ////////////SHOOTING STUFF/////////////
  
    if (gauntletLevel >27 && handsHolding == false && gauntletIMUx > 70  && gauntletIMUx<100 && gauntletIMUz <0) {
      if (shootOn == false ) {
        shootOn = true;
        power.pause();
        power.rewind();
        gauntletWipe();
        delay(250);
        shoot.trigger();
        gauntletColor("white", 255, 28);
        delay(1000); 
        gauntletLevel =0;
        shootOn = false;
        attackStrength = attackStrength * .5;
      }
    }

    //println(handsHolding);//FOR DEBUG
  } 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  else if (state == GAMEOVER) {
    gameSong.pause();
    restSong.pause();
    if (health>0) {
      gauntletColor("flash", 255, 28);
      tankColor("flash", 255, 10);
    } else {
      gauntletColor("fire", 100, 28);
      tankColor("fire", 100, 10);
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


////////FUNCTIONS////////////////

void resetEverything() {
  state = REST;
  gameSong.pause();
  gameSong.rewind();
  gameOverSong.pause();
  gameOverSong.rewind();
  restSong.pause();
  restSong.rewind();
  handsHolding = false;
  setUpTimer();

  gauntletWipe();
  tankWipe();
  ELOff();
health = startingHealth; 
  success=0;
  hurt = 0;
 
  tankDuckOnce = false;
}

void checkTank() {
//  println(sweetSpot);
  if (proxVal >80) {

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

void depleteFast() {
  counterDepleteFast++;
  if (counterDepleteFast%50 ==0) {
    tankLevel --;
  }
}


void tankDuckCheck(){
//if ((tankIMUz-lastTankIMUz)<-40){
//println("++++++++++DUCKED+++++++");
//}

if ((tankIMUz-lastTankIMUz)<-40 && tankDuckOnce == false ){
 println("*********DUCKED!!********");
  tankDuckOnce = true;
}
 lastTankIMUz = tankIMUz;
}