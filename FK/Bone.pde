class Bone {

  float dir = random(-1, 1);
  float mag = random(50, 150);

  ArrayList<Bone> children = new ArrayList<Bone>();
  Bone parent;

  boolean isRevolute = true;
  boolean isPrismatic = true;

  PVector worldStart; //start of bone in WS
  PVector worldEnd; //end of bone in WS
  float worldDir; //duh
  
  int boneDepth = 0; //how far down the tree this bone is
  float wiggleOffset = random(0, 4);
  float wiggleAmp = random(.01f, .2);
  float wiggleTimeScale = random(.01, .3);
  

  Bone(Bone parent) {
    this.parent = parent;
    
    int num = 0;
    
    Bone p = parent;
    while(p != null){
      num++;
      p = p.parent;
    }
    boneDepth = num;
  }


  Bone(int chainLength) {

    if (chainLength > 1) {
      
        addBone(chainLength - 1);
      
      //*OLD* child = new Bone(chainLength -1);
      //*OLD* child.parent = this;
    }
  }


  void addBone(int chainLength) {

    if (chainLength < 1) chainLength = 1;

    int numOfChildren = (int)random(1, 4);
    for (int i = 0; i < 3; i++) {

      Bone newBone = new Bone(this);
      children. add(newBone);
      newBone.parent = this;

      if (chainLength > 1) {

        newBone.addBone(chainLength - 1);
      }
    }
  }



  void draw() {
    fill(0);
  text(boneDepth, worldStart.x, worldStart.y - 30);
    line(worldStart.x, worldStart.y, worldEnd.x, worldEnd.y);

    //fill(100, 100, 200);
    ellipse (worldStart.x, worldStart.y, 15, 15);

    for (Bone child : children) child.draw();

    //if (child != null) child.draw();
    //fill()
    ellipse (worldEnd.x, worldEnd.y, 10, 10);
  }

  void calc() {

    if (parent != null) {

      worldStart = parent.worldEnd;
      worldDir = parent.worldDir + dir;
      
    } else {
      worldStart = new PVector (width/2, height/2);

      worldDir = dir;
    }
    
    worldDir += sin((time+wiggleOffset) * wiggleTimeScale) * wiggleAmp;
    //worldDir += sin(time*5) * ((boneDepth +1) / 1000.0);
    
    
    
    PVector localEnd = PVector.fromAngle(worldDir); //new PVector(mag * cos(worldDir), mag * sin(worldDir));
    localEnd.mult(mag);

    worldEnd = PVector.add(worldStart, localEnd);

    //*OLD* if (child != null) child.calc();
    for (Bone child : children) child.calc();
  }

  Bone onClick() {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldEnd);

    if (vToMouse.magSq() < 20 * 20) return this;

    // *OLD* if (child != null) return child.onClick();
    for (Bone child : children) {
      Bone b = child.onClick();
      if (b != null) return b;
    }

    return null;
  }

  void drag() {

    PVector mouse = new PVector(mouseX, mouseY);

    PVector vToMouse = PVector.sub(mouse, worldStart);

    if (parent != null && isRevolute) {
      dir =  vToMouse.heading() - parent.worldDir;//atan2(vToMouse.y, vToMouse.x);
    } else {
      dir = vToMouse.heading();
    }
    if (isPrismatic) {
      mag = vToMouse.mag();
    }
  }
}
