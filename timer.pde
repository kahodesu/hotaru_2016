
int gameTime = 60000; //LENGTH OF GAME
int fireTime = 50; 
int fireTime2 = 50; 
int flashTime = 20; 
int flashTime2 = 20; 
int gameOverTime = 60000;
int depleteTankTime = 2000;
int fillGauntletTime = 2000;
int shootPauseTime = 500;
int chargeGauntletTime = 150;

//TIME VARS
Timer gameTimer, fireTimer,fireTimer2,  flashTimer, flashTimer2, gameOverTimer, depleteTankTimer, fillGauntletTimer, shootPauseTimer, chargeGauntletTimer; 

void setUpTimer() {
  fireTimer = new Timer(fireTime);
 fireTimer2 = new Timer(fireTime2);
  flashTimer = new Timer(flashTime);
flashTimer2 = new Timer(flashTime2);
  gameOverTimer = new Timer(gameOverTime);
depleteTankTimer = new Timer(depleteTankTime);
fillGauntletTimer = new Timer(fillGauntletTime);
shootPauseTimer = new Timer(shootPauseTime);
chargeGauntletTimer = new Timer(chargeGauntletTime);

  fireTimer.start();
 fireTimer2.start();
  flashTimer.start();
 flashTimer2.start();
  depleteTankTimer.start();
  fillGauntletTimer.start();
}

//////////////////////////////////////////////////////////
// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com
// Example 10-5: Object-oriented timer

class Timer {
 
  int savedTime; 
  int totalTime; 
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  void start() {
    savedTime = millis(); 
  }
  
  boolean isFinished() { 
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}