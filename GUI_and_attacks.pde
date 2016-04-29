///////////LIBRARIES////////////
import interfascia.*;

///////////VARIABLES TO SET////////////
IFLookAndFeel defaultLook;
GUIController c;
IFTextField glText, a1Text, a2Text, a3Text, a4Text;
IFLabel titleLabel, glLabel, glHint, a1Label, a1Hint, a2Label, a2Hint, a3Label, a3Hint, a4Label, a4Hint ;
IFButton submitButton, resetButton, playButton, pauseButton, attractButton;

int gameLength= 60;
float currentTime = 0;
float cursorPoint = 0;
float startTime = 0;
boolean gameOn = false;
boolean pauseOn = false;
float pauseTime =0;
int stage1Attacks, stage2Attacks, stage3Attacks;
int totalAttacks;
int[] attackTimes = new int[0];
boolean[] attacked = new boolean[0];
boolean[] lastAttacked = new boolean[0];
boolean attractOn = false;
boolean firstSubmit = false; 
int healthBeforeDeath = 3; 
//////////////FUNCTIONS////////////////
void setupGUI () {

  c = new GUIController(this);

  //glText, a1Text, a2Text, a3Text
  glText= new IFTextField("", width/3-50, 150, 45, "120"); //1 min = 60 seconds, 2 mins = 120 seconds, 3 minds = 180 seconds
  a1Text= new IFTextField("", width/3-50, 200, 45, "0");
  a2Text= new IFTextField("", width/3-50, 225, 45, "2");
  a3Text= new IFTextField("", width/3-50, 250, 45, "3");
 a4Text= new IFTextField("", width/3-50, 280, 45, "3");

  //glLabel, glHint, a1Label, a1Hint, a2Label, a2Hint, a3Label, a3Hint;
  titleLabel = new IFLabel("", width/2-75, 25);
  glLabel = new IFLabel("Game Length\n(seconds):", 50, 155);
  glHint = new IFLabel("* default 120", width/3, 155);
  a1Label = new IFLabel("Stage1 Attacks:", 50, 205);
  a1Hint = new IFLabel("* default 0", width/3, 205);
  a2Label = new IFLabel("Stage2 Attacks:", 50, 230);
  a2Hint = new IFLabel("* default 2", width/3, 230);
  a3Label = new IFLabel("Stage3 Attacks:", 50, 255);
  a3Hint = new IFLabel("* default 3", width/3, 255);
  a4Label = new IFLabel("Health Before\nDeath:", 50, 280);
  a4Hint = new IFLabel("* default 3", width/3, 280);

  submitButton = new IFButton ("SUBMIT", width/3-50, 325, 100, 20);
  resetButton = new IFButton ("RESET", width/2-50, 550, 100, 20);
  playButton = new IFButton ("PLAY \n (space bar)", 2*width/5-50, 475, 100, 40);
  pauseButton = new IFButton ("PAUSE  \n  (space bar)", 3*width/5-50, 475, 100, 40);
  attractButton = new IFButton ("ATTRACT MODE", width/2-125, 115 , 250, 20);

  submitButton.addActionListener(this);
  resetButton.addActionListener(this);
  playButton.addActionListener(this);
  pauseButton.addActionListener(this);
  attractButton.addActionListener(this);

  defaultLook = new IFLookAndFeel(this, IFLookAndFeel.DEFAULT);
  defaultLook.baseColor = color(0, 225, 225);
  defaultLook.highlightColor = color(32,178,170);
  defaultLook.activeColor = color(225, 30, 30);
  defaultLook.borderColor = color(0, 225, 225);

  
  c.setLookAndFeel(defaultLook);

  c.add (titleLabel);
  c.add (glLabel);
  c.add (glHint);
  c.add (a1Label);
  c.add (a1Hint);
  c.add (a2Label);
  c.add (a2Hint);
  c.add (a3Label);
  c.add (a3Hint);
  c.add (a4Label);
  c.add (a4Hint);
  c.add (glText);
  c.add (a1Text);
  c.add (a2Text);
  c.add (a3Text);
c.add (a4Text);
  c.add (submitButton);
  c.add (resetButton);
  c.add (playButton);
  c.add (pauseButton);
   c.add (attractButton);
  

  
}

void drawLine() {
  strokeWeight(1);
  stroke(0); //stroke Black
  line(50, 400, width-50, 400); //big horizontal line
  line(50, 395, 50, 405); //furthest left marker
  line(50+((width-100)/3), 395, 50+((width-100)/3), 405); //first third marker
  line(50+(2*(width-100)/3), 395, 50+(2*(width-100)/3), 405); //second third marker
  line(width-50, 395, width-50, 405); //furhtest right marker
}

void calcAttack() {
  totalAttacks = stage1Attacks+stage2Attacks+stage3Attacks;
  attackTimes = new int[totalAttacks];
  attacked = new boolean[totalAttacks];
  lastAttacked = new boolean[totalAttacks];

  if (stage1Attacks >0) {
    println("-----stage 1");
    int attackSegments = gameLength/3/stage1Attacks;
    for (int i =0; i <stage1Attacks; i++) {
      int calcVal = int(random((0+(attackSegments*i)+5), (attackSegments*(1+i))));
      attackTimes[i]= calcVal;
      println(calcVal);
    }
  }
  if (stage2Attacks >0) {
    println("-----stage 2");
    int attackSegments = gameLength/3/stage2Attacks;
    for (int i =0; i <stage2Attacks; i++) {
      int calcVal = int(random(((attackSegments*i)+(gameLength/3)+5), (attackSegments*(1+i))+(gameLength/3)));
      attackTimes[i+stage1Attacks]= calcVal;
      println(calcVal);
    }
  }
  if (stage3Attacks >0) {
    println("-----stage 3");
    int attackSegments = gameLength/3/stage3Attacks;
    for (int i =0; i <stage3Attacks; i++) {
      int calcVal = int(random(((attackSegments*i)+(2*gameLength/3)+5), (attackSegments*(1+i))+(2*gameLength/3)));
      attackTimes[i+stage2Attacks+stage1Attacks]= calcVal;
      println(calcVal);
    }
  }
  attackTimes= sort(attackTimes);
  printArray(attackTimes);
}

void drawAttacks() {
  fill(255, 0, 0);
  stroke(0);
  for (int i =0; i <totalAttacks; i++) {
    ellipse(50+((width-100)*(float)attackTimes[i] / (float)gameLength), 400, 6, 6); //FU FLOATS
  }
}

void drawCursor() {  
  if (gameOn && pauseOn == false) {
    currentTime = millis()-startTime;
  //  println(currentTime/float(1000) + "," + gameLength);
    cursorPoint = 50+(currentTime/float(1000)*((width-100)/gameLength));
    stroke(0);
    fill(255);
    checkAttack();
  } else if (gameOn && pauseOn) {
    stroke(150);
    fill(150);
  } else {
    cursorPoint = 50;
    stroke(0);
    fill(0);
  
  }
  triangle(cursorPoint, 390, cursorPoint-5, 380, cursorPoint+5, 380);
  if(currentTime/float(1000) > gameLength) {
  //////////////////END OF GAME /////////////////////////
    gameOverTimer.start();
  
    println("############################");
println("############################");
println("############################");
    state = GAMEOVER; 
  
    //currentTime = 0;
    //this is where you will show the results for a few secounds then.... reset

  }

 
}

void actionPerformed (GUIEvent e) {

///////////////////SUBMIT///////////////////
  if (e.getSource() == submitButton) {
    println("--SUBMIT--");
    println(glText.getValue());
    gameLength =int(glText.getValue());
    stage1Attacks = int(a1Text.getValue());
    stage2Attacks = int(a2Text.getValue());
    stage3Attacks= int(a3Text.getValue());
    calcAttack();
    firstSubmit = true; 
  } 

///////////////////RESET///////////////////
    else if (e.getSource() == resetButton) {
    pressReset();
  } 

///////////////////ATRRACT///////////////////
    else if (e.getSource() == attractButton) {
    if (gameOn == false) {
      attractOn = !attractOn;
    }
  } 

///////////////////PLAY///////////////////
  else if (e.getSource() == playButton) {
    pressPlay();
  } 

///////////////////PAUSE///////////////////
  else if (e.getSource() == pauseButton) {
    pressPause();
  }
  ding.trigger();
}

void pressPlay() {
  if (firstSubmit == true) {
attractOn = false; 
  state = GAME;
  restSong.pause();
  if (pauseOn == false) {
    startTime = millis();
    gameOn = true;
  } else {
    startTime = startTime + (millis()- pauseTime);
    pauseOn= false;
  }
chargeGauntletTimer.start();
  }

}


void pressReset() {
    gameOn = false;
    pauseOn= false;
    gameSong.pause();
    gameSong.rewind();
    gameOverSong.pause();
    gameOverSong.rewind();
    restSong.pause();
    restSong.rewind();
   state = REST;
   println("--RESET--");
 gauntletWipe();
  tankWipe();
  tankColor("white", 255, 10);
  tankShow();
 resetEverything();
  return;
}


void pressPause() {
  println("--PAUSE--");
  if (pauseOn == false && gameOn) {
    pauseOn= true;
    pauseTime = millis();
    gameSong.pause();
  }
}

void keyPressed() {
  if (key == ' ') {
    if (pauseOn ==false && gameOn) {
      pressPause();
    } else {
      pressPlay();
    }
  }
}

void checkAttack(){
   for (int i=0; i < totalAttacks; i++){
    if (currentTime/float(1000) > attackTimes[i]) {
        attacked[i] = true;
    }
    else {
        attacked[i] =false;
    }
    if (lastAttacked[i] != attacked[i]) {
      //warning.trigger(); 
      overallHealth =  overallHealth - int(float(totalHealth)/ float(attackTimes.length));
      if(!warning.isPlaying()){
      warning.rewind();
        warning.play();
        overallHealth = overallHealth - 10;
}
    }
    lastAttacked[i] = attacked[i];
  }
}

void checkHealth() {
    println("overallHealth: "+overallHealth);
   
}