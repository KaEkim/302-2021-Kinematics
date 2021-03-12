
Bone bone = new Bone(5);

float time = 0;

Bone draggedBone;



void setup(){
  size(600, 600, FX2D);
  //bone.child = new Bone();
  //bone.child.parent = bone;
}

void draw(){
  
  time = millis()/1000.0;
  background(128);
  
  if (draggedBone != null) draggedBone.drag();
  
  bone.calc();
  bone.draw();
}
  void mousePressed(){
    //bone = new Bone(5);
    Bone clickedBone = bone.onClick();  
    if (Keys.SHIFT()){
      
      if (clickedBone != null){
        clickedBone.addBone(1);
      }
      
    }
    else{
      if (clickedBone != null){
        draggedBone = clickedBone;
      }
    }
}

void mouseReleased(){
  draggedBone = null;
}
