class Preset {
  String nickname; 
  ArrayList fTexture;
  ArrayList sTexture;
  ArrayList pTexture;
  ArrayList lTexture;
  ArrayList flicker; 
  
  Preset(String name) {
    nickname = name; 
    fTexture = new ArrayList();
    sTexture = new ArrayList();
    pTexture = new ArrayList();
    lTexture = new ArrayList();
    flicker = new ArrayList();
  }
  
  void addParticle(int texID, int texSize, int freq, int layer, Boolean f) {
    fTexture.add(freq); 
    sTexture.add(texSize); 
    pTexture.add(texID);
    lTexture.add(layer); 
    flicker.add(f);  
  }
  
  String getName() {
    return nickname;  
  }
  
  int getSize(int id) {
    int theArray = (Integer) sTexture.get(id); 
    return theArray; 
  }
  
  int getTexture(int id) {
    int theArray = (Integer) pTexture.get(id); 
    return theArray; 
  }
  
  int getLayer(int id) {
    int theArray = (Integer) lTexture.get(id); 
    return theArray; 
  }
  
  Boolean getFlicker(int id) {
    Boolean theArray = (Boolean) flicker.get(id); 
    return theArray; 
  }
  
  int getFrequency(int id) {
    int theArray = (Integer) fTexture.get(id); 
    return theArray; 
  }
  
  int getArraySize() {
    return fTexture.size(); 
  }
  
  void draw() {
    for ( int i = 0; i < this.getArraySize(); i++ ) {
      eventVisual(this.getFrequency(i), particleLayer[this.getLayer(i)], this.getTexture(i), 1.0, random(width), random(height),2);
    } 
  }
  
}

class PresetManager {
  ArrayList preset; 
  int currentPreset; 
  
  PresetManager() {
    preset = new ArrayList(); 
    currentPreset = 0;  
  }
  
  
  void addPreset(String presetname) {
    preset.add(new Preset(presetname));    
  }
  
  Preset getCurrent() {
    Preset current = (Preset) preset.get(currentPreset); 
    return current; 
  }  

  Preset getPreset(int requested) {
    Preset thePreset = (Preset) preset.get(requested);
    return thePreset;    
  }
  
  Preset getPreset(String requested) {
  Preset thePreset = null; 
   for ( int i = 0; i < preset.size(); i++ ) {
      Preset presetFromArray = (Preset) preset.get(i);
      if ( presetFromArray.getName() == requested ) { 
        thePreset = presetFromArray; 
      } 
    } 
  return thePreset;
  }
  
  void changePreset(String requested) {
   for ( int i = 0; i < preset.size(); i++ ) {
      Preset presetFromArray = (Preset) preset.get(i);
      if ( presetFromArray.getName() == requested ) { 
        currentPreset = i; 
      }
    } 
  }
  
  void draw() {
     getCurrent().draw();  
  }
  
}
