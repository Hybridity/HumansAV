// this class if pretty specific to Humans
class AudioManager {
  FFT fft;   
  AudioInput input; 
  int bufferSize; 
  PApplet managerParent;
  
  float bassValue;
  float midValue;
  float highValue;

  float bassUpdateValue;
  float midUpdateValue;
  float highUpdateValue; 
  
  int bassBreak;
  int highBreak; 
  
  AudioManager(PApplet parent, int buffer) {
    bufferSize = buffer; 
    managerParent = parent; 
    
    bassBreak = 100;
    highBreak = 200; 
    
    /*Ess.start(parent);
    input=new AudioInput(bufferSize);
    input.start();*/

    fft=new FFT(bufferSize*2);
    fft.damp(.3);
    fft.equalizer(true);
    fft.limits(.005,.05);
  }
  
  void changeBreak(int low, int high) {
    bassBreak = low;
    highBreak = high;   
  }
  
  void update() {
    // reset the temp values
    // ** TODO: build an eq monitor class so that there is less variable management in AudioManager. 
    bassUpdateValue = 0;
    midUpdateValue = 0;
    highUpdateValue = 0; 
    
    for (int i=0; i<bufferSize; i++) {
      if ( i > 0 && i < bassBreak) bassUpdateValue = bassUpdateValue + fft.spectrum[i];
      if ( i > bassBreak && i < highBreak) midUpdateValue = midUpdateValue + fft.spectrum[i];
      if ( i > highBreak && i < bufferSize) highUpdateValue = highUpdateValue + fft.spectrum[i];
     } 
    
     bassValue = bassUpdateValue / bassBreak * 10;// / bassBreak; // divide to get an average
     midValue = (midUpdateValue / (highBreak - bassBreak)) *10; // divide to get an average
     highValue = (highUpdateValue / (bufferSize - highBreak))*10; // divide to get an average
     
   //  println("[ " + bassValue + " ] [ " + midValue + " ] [ " + highValue + " ] ");
     
  }
  
  float getBass() {
    return bassValue;  
  }
  
  float getMid() {
    return midValue;  
  }
  
  float getHigh() {
    return highValue;   
  }
  
  void getSpectrum(AudioInput theInput) {
    fft.getSpectrum(theInput);
  }
  
  
  
}
