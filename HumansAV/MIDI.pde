void controllerChangeReceived(Controller ctl) {

  println("Control change " + ctl.getCC() + " -> " + ctl.getValue());
  
  switch (ctl.getCC()) { 
    // Other Frames speed
    case 74: // this signals a knob change
      backgroundSlideshow.rateChange(127 - ((ctl.getValue()/5) + 100)-1);
      break;
      
    case 81:
      presetManager.changePreset("bokeh1"); 
      break;
  
    case 82:
      presetManager.changePreset("squares"); 
      break;
      
    case 65:
      presetManager.changePreset("glass"); 
      break; 

    case 83:
      presetManager.changePreset("dust"); 
      break;        
      
    case 84:
      presetManager.changePreset("lcd"); 
      break;   
    
    case 85:
      presetManager.changePreset("lines"); 
      break;
   
   case 86:
      backgroundSlideshow.changeSet("forest"); 
      break;   
   
   case 87:
      backgroundSlideshow.changeSet("saopaolo"); 
      break;   
   
   case 88:
      backgroundSlideshow.changeSet("falsecreek"); 
      break;      
    
    case 7:
      midiVars.changeBrightness(ctl.getValue()/127.0);
      break;   
    
    case 71:
      midiVars.changeVelocity(ctl.getValue()/127.0);
      break;   
  
    case 5:
      midiVars.changeAudioZone(ctl.getValue()/127.0);
      break;     
      
    case 75:
      midiVars.changeVolumeScale(ctl.getValue()/127.0);
      break;     
      
    case 91:
      midiVars.changeFlickerScale(ctl.getValue()/127.0);
      break;  
      
    case 72:
      if (ctl.getValue() >= 100 ) {
       blendOrder[0] = 2;  
       blendOrder[1] = 3;  
       blendOrder[2] = 0;  
      } else {
       blendOrder[0] = 0;  
       blendOrder[1] = 0;  
       blendOrder[2] = 0;  
      }
  }
}

class MidiVars {
  float globalBrightness;
  float velocityScale;
  float volumeScale;
  int audioZone;
  float flickerScale;
  
  MidiVars() {
    globalBrightness = 0.0; 
    velocityScale = 0.0;
    audioZone = 0;
    flickerScale = 0; 
  }
  
  void changeFlickerScale(float a) {
    flickerScale = a;   
  }
  
  float getFlickerScale() {
    return random(flickerScale * -50, 0.0);
  }  
  
  
  void changeBrightness(float a) {
    globalBrightness = a;   
  }
  
  float getBrightness() {
    return globalBrightness;
  }  
  
  void changeVolumeScale(float a) {
    volumeScale = a * 200;
  }
  
  float getVolumeScale() {
    return volumeScale;
  }  
  
  void changeVelocity(float a) {
    velocityScale = a;
  }
  
  float getVelocity() {
    return velocityScale;
  }  
  
  void changeAudioZone(float a) {
    audioZone = int((a * 312) + 100);  
    audio.changeBreak(audioZone-100,audioZone+100); 
  }
  
  int getAudioZone() {
    return audioZone;  
  }
}
