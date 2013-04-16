// A simple Particle class

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  float lifespan; 
  GLTexture tex; // added texture to use
  int focus; 
  
  // modified particle to pass more parameters  
  Particle(PVector l, float rad, float v, GLTexture t, float life) {
    float a = (v/10.0);
    acc = new PVector(random(-a,a),random(-a,a),0);
    vel = new PVector(random(-v,v),random(-v,v),0);
    loc = l.get();
    r = rad;
    lifespan = life; 
    timer = 512.0;
    tex = t;
    focus = int(random(1,3)); 
  }

  // added run function with destination offscreen to draw on 
  void run(GLGraphicsOffScreen dest) {
    update();
    render(dest);
  }
  
  // Method to update location
  void update() {
    vel.add(acc);
    vel.mult(midiVars.getVelocity());
    //println(vel);
    loc.add(vel);
    timer -= 1*lifespan; // def 2
  }
  
  // temp class. 
  float brightnessModulator(int i) {

      if ( i == 1 ) { 
        return (audio.getBass() * midiVars.getVolumeScale()); 
      } else if ( i == 2 ) {
        return (audio.getMid() * midiVars.getVolumeScale()); 
      } else if ( i == 3 ) {
        return (audio.getHigh() * midiVars.getVolumeScale()); 
      } else {
        return (audio.getMid() * midiVars.getVolumeScale()); 
      }

  } 
  
  
//    float brightnessModulator(int i) {
//float multiplyer = 0; 
//      if (timer < 256) {
//        multiplyer = norm (timer,0,256); 
//      }
//      if (timer >= 256) {
//        multiplyer = norm (timer,512,256); 
//      }
//      if ( i == 1) { 
//        return ((audio.getBass() * (midiVars.getVolumeScale()) *  midiVars.getBrightness() )*multiplyer ); 
//      } else if ( i == 2 ) {
//        return ((audio.getMid() * (midiVars.getVolumeScale()) *  midiVars.getBrightness() )*multiplyer ); 
//      } else if ( i == 3 ) {
//        return ((audio.getHigh() * (midiVars.getVolumeScale()) *  midiVars.getBrightness() )*multiplyer ); 
//      } else {
//        return ((audio.getMid() * (midiVars.getVolumeScale()) *  midiVars.getBrightness() )*multiplyer ); 
//      }
//  } 

// vagina. 


//  // Method to display
  void render(GLGraphicsOffScreen dest) {
    
    // fade in-fade out (timer starts at 512)
    if(timer>255) {
        dest.tint(200,((511-timer) * midiVars.getBrightness()) - midiVars.getFlickerScale() + (brightnessModulator(focus)*1)   ); // def : 255 

    } else {
      dest.tint(200,(timer * midiVars.getBrightness()) - midiVars.getFlickerScale() + ((brightnessModulator(focus)*1)));     // def : 255 
    }
    
    // write texture on x and y position with radius r. 
    // texture is centered by (r/2);
    dest.image(tex, loc.x-(r/2),loc.y-(r/2), r, r);
    
    //displayVector(vel,loc.x,loc.y,10);
  }
  
  
  
    // Method to display
//  void render(GLGraphicsOffScreen dest) {
//    
//    // fade in-fade out (timer starts at 512)
//    if(timer>255) {
//        dest.tint(200,brightnessModulator(focus)); // def : 255 
//
//    } else {
//      dest.tint(200,brightnessModulator(focus));     // def : 255 
//    }
//    
//    // write texture on x and y position with radius r. 
//    // texture is centered by (r/2);
//    dest.image(tex, loc.x-(r/2),loc.y-(r/2), r, r);
//    
//    //displayVector(vel,loc.x,loc.y,10);
//  }
  
  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
   void displayVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  } 

}

