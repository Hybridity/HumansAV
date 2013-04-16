// updated Slideshow class for Humans A/V
// implements loop points to create sets of Other Frames

// A moving image layer, handled by an array

class Slideshow {
  int framesPerChange;
  GLTexture[] textureArray;  
  int currentImage =  0; 
  int imageTotal; 
  int startLoop;
  int endLoop; 
  int currentSet; 
  ArrayList frameSet;
  
  // "Sets" should really be built as an object. Some day. 
  
  Slideshow(PApplet parent, int newRate, String pathName, int howMany) {
    framesPerChange = newRate;
    textureArray = new GLTexture[howMany];
    imageTotal = howMany; 
    startLoop = 0;
    endLoop = howMany-1; 
    frameSet = new ArrayList();
    
    frameSet.add(new FrameSet("all",0,endLoop));
    currentSet = 0; 
    
    for (int i=0; i < textureArray.length; i++) {
      textureArray[i] = new GLTexture(parent,"data/frames/" + pathName + "/" + pathName + "-" + (i+1) + ".jpg");  
      println("Loading Texture: " + pathName + "-" + (i+1) + ".jpg ... SUCCESS!");
    }
  }
 
  void rateChange(int newRate) {
    framesPerChange = newRate;  
  }
  
  // New Slideshow speed that accepts a float value and converts to integer. 
  void rateChange(float newRate) {
    framesPerChange = int(newRate);  
  }
  
  void addSet(String name, int start, int end) {
    frameSet.add(new FrameSet(name,start,end));
  } 
  
  void changeSet(String name) {
    for ( int i = 0; i < frameSet.size(); i++ ) {
      FrameSet setFromArray = (FrameSet) frameSet.get(i);
      if ( setFromArray.getName() == name ) { 
        currentSet = i;
      } 
    }
    FrameSet startChange = (FrameSet) frameSet.get(currentSet);
    FrameSet endChange = (FrameSet) frameSet.get(currentSet);
    
    startLoop = startChange.getStart(); 
    endLoop = endChange.getEnd(); 
    currentImage = startLoop; 
    
    println("Set change to: " + currentSet);
    
  }
  
  String currentSetName() {
    FrameSet setFromArray = (FrameSet) frameSet.get(currentSet); 
    return setFromArray.getName();   
  }
  
  // move to the next image in the set. 
  void nextImage() {
    if ( frameCount%framesPerChange==0 ) currentImage += 1;
    if ( currentImage == endLoop ) currentImage = startLoop; 
  }

  void update() {
    this.nextImage(); 
    
    // if (currentImage >= textureArray.length) currentImage = 0;  // simple counter. Obsolete with loop points. 
  } 
 
  GLTexture getCurrentTexture() {
    return textureArray[currentImage];  
  }
  
}

class FrameSet {
  String name;
  int start;
  int end;
  
  FrameSet(String inputName, int inputStart, int inputEnd) {
    name = inputName;
    start = inputStart;
    end = inputEnd; 
  }  
  
  int getStart() {
    return start; 
  }
  
  int getEnd() {
    return end;  
  }
  
  String getName() {
    return name;  
  }
  
}
