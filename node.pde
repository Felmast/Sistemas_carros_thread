class node {
  int x;
  int y;
  int size;
  boolean options;
  
  node(int x, int y, int size){
    this.x = x;
    this.y = y;
    this.size = size;
    this.options = false;
  }
    
  void drawNodo(){
     circle(x,y,size);
  }
  
  void option(){
    if(options){
      rect(x,y+10,70,100);
    }
  }
  
  void mouseDragged(){
     if(mouseX>=x-size/2 && mouseX <=x+size/2 && mouseY>=y-size/2 && mouseY<=y+size/2){
        x = mouseX;
        y = mouseY;
      } 
  }
  void mousePressed() {
    if(allowMP && mouseX>=x-size/2 && mouseX <=x+size/2 && mouseY>=y-size/2 && mouseY<=y+size/2){
         this.options = true;
      } 
  }
}
