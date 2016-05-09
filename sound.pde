
import ddf.minim.*;


Minim minim;

AudioSample ding, shoot;
AudioPlayer gameSong, restSong, gameOverSong, power, charge, warning;


void setupSound() {
  minim = new Minim(this);
  ding = minim.loadSample( "TANG.aiff" );
  warning = minim.loadFile( "warning.aiff" );
  restSong = minim.loadFile( "hotaru-game-loop.aiff" );
  gameSong = minim.loadFile( "hotaru-game-loop2.aiff" );
  gameOverSong = minim.loadFile( "endofgame.aiff" );
  power = minim.loadFile("power.wav");
  charge = minim.loadFile("charge.aiff");
  shoot = minim.loadSample( "shoot.wav");
}

void stop() {
}