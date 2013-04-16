/*

humans a/v the second. 
new and improved with i-av classes.

matt marshall
hybridity media

*/

// load GL environment
import processing.opengl.*;
import codeanticode.glgraphics.*;

// load and initialize the syphon server
import javax.media.opengl.*;
import jsyphon.*; // Syphon
JSyphonServer mySyphon;
PGraphicsOpenGL pgl;
GL gl;
int[] texID;

// load and initalize tuio
import TUIO.*;
TuioProcessing tuioClient;

// load and initialize sound input library
// ** NOTE: HA/V uses Ess sound library, not minim. Not good reason... just because. 
import krister.Ess.*;
AudioManager audio;
AudioInput audioInput;

// preset management
PresetManager presetManager;

// load and initialize MIDI
import rwmidi.*;
MidiInput input;
MidiVars midiVars;

// screen size
int scrWidth = 1024; 
int scrHeight = 768;

// how many particle layers? 
ParticleSystem[] particleLayer = new ParticleSystem[3]; // how many particle layers? 
int[] blendOrder = {0,0,0}; // based on layerFilter array in preloadGL(), need an int for every particle layer

GLTexture[] texArray = new GLTexture[21]; // # of particle textures
int[] texArraySize = new int[texArray.length]; 

// GL Environment Varialbes
GLTextureFilter[] layerFilter = new GLTextureFilter[5];
GLTexture[] layerArray = new GLTexture[particleLayer.length];
GLTexture outputImage = new GLTexture(); 
GLTexture backgroundImage = new GLTexture();
GLGraphicsOffScreen[] offscreen = new GLGraphicsOffScreen[particleLayer.length];
Slideshow backgroundSlideshow;

float globalBpm = 120; // we still need this to control particle creation speed. 

// ------ SETUP 
void setup() {
  
  frame.setBackground(new java.awt.Color(0,0,0));

  
  println("*** Humans A/V Startup..."); 
  // basic environment and screen settings
  size(scrWidth, scrHeight, GLConstants.GLGRAPHICS);
  frameRate(30);
  
  // init syphon
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  initSyphon(gl,"Syphon Output");
  println("*** ... Syphon is running"); 
  
  // open audio stream 
  Ess.start(this);
  audioInput=new AudioInput(512);
  audioInput.start();
  
  audio = new AudioManager(this,512);
  
  // init midi
  if ( RWMidi.getInputDevices().length == 1 ) {
    input = RWMidi.getInputDevices()[0].createInput(this); 
  } else {
    input = RWMidi.getInputDevices()[1].createInput(this); 
  }
  input.plug(this);
  midiVars = new MidiVars(); 

  // setup the GL environment
  preloadGL("data/img/background3.jpg");
  println("*** ... GL environment is running"); 
  
  // load other frames
  backgroundSlideshow = new Slideshow(this, 1, "otherframes_sets", 845);
  println("*** ... Other Frames loaded"); 
  
  backgroundSlideshow.addSet("forest",345,845);
  backgroundSlideshow.addSet("saopaolo",0,131);
  backgroundSlideshow.addSet("falsecreek",132,344);
  
  // load the particle textures
  loadTexture(0, "data/img/bokeh-512_grain.png", 512);
  loadTexture(1, "data/img/bokeh-256_grain.png", 256);
  loadTexture(2, "data/img/bokeh-128_grain.png", 128);
  loadTexture(3, "data/img/squaredistort_1024.png", 512);
  loadTexture(4, "data/img/squaredistort_1024b.png", 512);
  loadTexture(5, "data/img/squaredistort_1024c.png", 512);
  loadTexture(6, "data/img/ia_frame3.png", 512);
  loadTexture(7, "data/img/ia_frame4.png", 512);
  loadTexture(8, "data/img/ia_frame5.png", 512);
  loadTexture(9, "data/img/ia_frame1.png", 512);
  loadTexture(10, "data/img/ia_frame2.png", 512);
  loadTexture(11, "data/img/ia_frame6.png", 512);
  loadTexture(12, "data/img/stars1.png", 512);
  loadTexture(13, "data/img/stars2.png", 512);
  loadTexture(14, "data/img/stars3.png", 512);
  loadTexture(15, "data/img/lcd1.png", 512);
  loadTexture(16, "data/img/lcd3.png", 512);
  loadTexture(17, "data/img/lcd4.png", 512);
  loadTexture(18, "data/img/lcd5.png", 512);
  loadTexture(19, "data/img/forest_01.png", 1024);
  loadTexture(20, "data/img/forest_02.png", 256);
  println("*** ... Particle Textures loaded");
  
  // get the particle systems going
    // start particle systems
  for (int i = 0; i < particleLayer.length; i++) {
    particleLayer[i] = new ParticleSystem();
    println("*** ... Initializing Particle Layer " + (i + 1));  
  }
  
  // add the presets
  presetManager = new PresetManager(); 
  presetManager.addPreset("bokeh1");
  presetManager.getPreset("bokeh1").addParticle(0, 512, 10, 0, false);
  presetManager.getPreset("bokeh1").addParticle(1, 256, 15, 1, false);
  presetManager.getPreset("bokeh1").addParticle(2, 128, 60, 2, false);
  presetManager.addPreset("squares");
  presetManager.getPreset("squares").addParticle(3, 512, 25, 0, false);
  presetManager.getPreset("squares").addParticle(4, 512, 20, 1, false);
  presetManager.getPreset("squares").addParticle(5, 512, 5, 2, false);
  presetManager.addPreset("glass");
  presetManager.getPreset("glass").addParticle(6, 512, 25, 0, false);
  presetManager.getPreset("glass").addParticle(7, 512, 20, 1, false);
  presetManager.getPreset("glass").addParticle(8, 512, 5, 2, false);
  presetManager.addPreset("dust");
  presetManager.getPreset("dust").addParticle(12, 512, 7, 0, false);
  presetManager.getPreset("dust").addParticle(13, 512, 3, 1, false);
  presetManager.getPreset("dust").addParticle(14, 512, 5, 2, false);
  presetManager.addPreset("lcd");
  presetManager.getPreset("lcd").addParticle(15, 512, 7, 0, false);
  presetManager.getPreset("lcd").addParticle(15, 512, 3, 1, false);
  presetManager.getPreset("lcd").addParticle(15, 512, 5, 2, false);
  presetManager.addPreset("lines");
  presetManager.getPreset("lines").addParticle(19, 1024, 7, 0, false);
  presetManager.getPreset("lines").addParticle(19, 1024, 5, 1, false);
  presetManager.getPreset("lines").addParticle(20, 256, 3, 2, false);
  
  // we create an instance of the TuioProcessing client
  tuioClient = new TuioProcessing(this);    
}

void draw() {
  
  presetManager.draw(); 
  
  displayOutput();  
  audio.update(); 
  backgroundSlideshow.update(); 
}

public void audioInputData(AudioInput theInput) {
    audio.getSpectrum(audioInput);
}
