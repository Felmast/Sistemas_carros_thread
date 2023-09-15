class node {
  int x;
  int y;
  int size;
  float creationRate;
  boolean options;
  boolean setCreation;
  String input = "";

  node(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.setCreation = false;
    creationRate = 1.0;
  }

  void setCreationRate() {
    if (!input.equals(".") && input != "") {
      creationRate = float(input);
    }
    input = "";
  }

  node getNode() {
    if ( mouseX>=x-size/2 && mouseX <=x+size/2 && mouseY>=y-size/2 && mouseY<=y+size/2)
      return this;
    return null;
  }

  void mousePressed() {
    if (mousePressed && (mouseButton == RIGHT)) {
      if (mouseX>=x-size/2 && mouseX <=x+size/2 && mouseY>=y-size/2 && mouseY<=y+size/2) {
        if (setCreation) {
          setCreationRate();
        }
        this.setCreation = !this.setCreation;
      }
    }
  }

  void keyPressed() {
    if (setCreation) {
      if (key >= '0' && key <= '9')
        input += key;
      if (key == '.')
        input += key;
    }
  }

  void draw() {
    if (setCreation)
      fill(#F0EBEB);
    else
      fill(255); //Color black
    circle(x, y, size);
    fill(0); //Color black
    textSize(18);
    if (setCreation)
      text(input, x-10, y+5);
    else
      text(creationRate + " ", x-10, y+5);
    fill(255); //Color black
  }
}
