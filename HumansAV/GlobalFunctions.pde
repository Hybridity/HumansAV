// displays the loading screen
void displayLoading(String img) {
  PImage loading = loadImage(img);
  image(loading, 0, 0, width, height); 
}

// pre loads and sets up all the GL Texture shenanigans
void preloadGL(String img) {
   // load the  different filter types into an array.
  // ************************ TODO: Finalize the blend list, document the list, make a function?
  layerFilter[0] = new GLTextureFilter(this, "data/blend/BlendColorDodge.xml");
  layerFilter[1] = new GLTextureFilter(this, "data/blend/BlendAdd.xml");
  layerFilter[2] = new GLTextureFilter(this, "data/blend/BlendHardLight.xml");
  layerFilter[3] = new GLTextureFilter(this, "data/blend/BlendOverlay.xml");
  layerFilter[4] = new GLTextureFilter(this, "data/blend/BlendScreen.xml");
  
  // the background image. Most environments use a slideshow as the background. What is the background is defined in the displayOutput() function
  backgroundImage = new GLTexture(this,img); 
  
  // init the final output image
  outputImage = new GLTexture(this,scrWidth,scrHeight); 
  
  // init all the offscreen textures
  for(int i = 0; i < offscreen.length; i++) {
    offscreen[i] = new GLGraphicsOffScreen(this, scrWidth, scrHeight); 
  }
  
}

// compiles and blends the final image for output
void displayOutput() {
  
  // draw all the existing particles
  drawParticles();
  
  // save current offscreen state to layerArray
  for ( int i = 0; i < layerArray.length; i++) {
    layerArray[i] = offscreen[i].getTexture();
  }
  
  // blend it all together, changing the array position in the layerFilter will change the blend type.
  // if i==0 is where to define the background image. 
  for (int i = 0; i < layerArray.length; i++) { 
    if (i==0) {
      //layerFilter[4].apply(new GLTexture[]{foregroundSlideshow.getCurrentTexture(), backgroundSlideshow.getCurrentTexture()}, outputImage);
      layerFilter[blendOrder[i]].apply(new GLTexture[]{backgroundSlideshow.getCurrentTexture(), layerArray[0]}, outputImage); 
    } else {
      layerFilter[blendOrder[i]].apply(new GLTexture[]{outputImage, layerArray[i]}, outputImage);
    }
  }
  
  // display the outputImage
  image(outputImage, 0, 0); 
  
  // output to Syphon
  renderTexture(pgl.gl);
}

// loads a texture into array, normally used for particle textures
void loadTexture(int id, String file, int s) {
  texArray[id] = new GLTexture(this,file);
  texArraySize[id] = s; 
}

// draws all the particles off screen prior to blending. 
void drawParticles() {
  for (int i = 0; i < particleLayer.length; i++) {
    drawOffscreen(particleLayer[i],offscreen[i]);
  }
}

// draws offscreen prior to blending
void drawOffscreen(ParticleSystem p, GLGraphicsOffScreen o)
{ o.beginDraw();
  o.clear(0, 0);
  o.background(0);
  p.run(o);
  o.endDraw();
}

// main function for triggering a visual event
// (every x frames, use this texture, with this initial velocity, at x, at y
void eventVisual(int t, ParticleSystem ps, int texID, float v, float x, float y, float l ) { // frames per iteration, Particle System, x, y, texID #, velocity
  if(frameCount%t==0) ps.addParticle(int(x),int(y), texArraySize[texID], v, texArray[texID], l);
  //println("X = " + x); // debugger
  //println("Y = " + y); // debugger
}

// randomised version if no x/y given
void eventVisual(int t, ParticleSystem ps, int texID, float v, float l) {
  eventVisual(t, ps, texID, v, random(width), random(height), l);   
}

// main function for triggering a sound/instrument event
// ***** TODO: Build a function for a sound event
void eventSound() {
  
}

float bars(float b) { // 'b' is how many bars we want to convert
  float bars = (((globalBpm/4)/15)*b)*30;
  return bars; 
}

Boolean barsEvery(float b) { // 'b' - how many bars have passed
  Boolean play;
  if (frameCount%bars(b)==0) {
    play = true; 
  } else {
    play = false;
  }
  
  return play;
}
