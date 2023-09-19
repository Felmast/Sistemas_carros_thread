class path {
  int x_node1;
  int y_node1;
  int x_node2;
  int y_node2;
  int value;
  int indiceNodo1;
  int indiceNodo2;
  boolean edit=false;
  String input = "";
  boolean mouseOn = false;

  path() {
  }

  void setNode1(int x, int y, int indiceNodo1 ) {
    this.x_node1 = x;
    this.y_node1 = y;
    this.indiceNodo1 = indiceNodo1;
  }

  void setNode2(int x, int y, int indiceNodo2) {
    this.x_node2 = x;
    this.y_node2 = y;
    this.indiceNodo2 = indiceNodo2;
  }

  void setValue(int value ) {
    this.value = value;
  }

  int getNode1() {
    return indiceNodo1;
  }
  int getNode2() {
    return indiceNodo2;
  }
  path getPath() {
    return this;
  }

  void editValue() {
    if (input != "") {
      this.value = int(input);
    }
    input = "";
    print(value);
  }

  void keyPressed() {
    if (edit) {
      if (key >= '0' && key <= '9')
        input += key;
      if (key == '.')
        input += key;
    }
  }

  void mouseMoved() {
    if (mouseX>= (x_node1+x_node2)/2 && mouseX <= (x_node1+x_node2)/2 + 40 && mouseY>= (y_node1+y_node2)/2  && mouseY<= (y_node1+y_node2)/2 + 23 )
      mouseOn = true;
    else
      mouseOn = false;
  }

  void mousePressed() {

    if (!simulationOn && mousePressed && (mouseButton == RIGHT)) {
      if (mouseX>= (x_node1+x_node2)/2 && mouseX <= (x_node1+x_node2)/2 + 40 && mouseY>= (y_node1+y_node2)/2  && mouseY<= (y_node1+y_node2)/2 + 23 ) {
        if (edit) {
          editValue();
        }
        this.edit = !this.edit;
      }
    }
  }

  void draw() {
    strokeWeight(3);
    stroke(0);
    line(x_node1, y_node1, x_node2, y_node2);
    strokeWeight(1);
    textSize(20);
    if (edit) {
      fill(#F0EBEB);
      rect((x_node1+x_node2)/2, (y_node1+y_node2)/2, 40, 23);
      fill(0);
      text(input, (x_node1+x_node2+5)/2, (y_node1+y_node2+35)/2);
    } else {
      rect((x_node1+x_node2)/2, (y_node1+y_node2)/2, 40, 23);
      fill(0);
      text(value, (x_node1+x_node2+5)/2, (y_node1+y_node2+35)/2);
    }
    if (!simulationOn && mouseOn && !edit) {
      fill(0);
      text("Right click to edit", mouseX, mouseY);
      fill(255);
    }
    if (!simulationOn && mouseOn && edit) {
      fill(0);
      text("Right click to save", mouseX, mouseY);
      fill(255);
    }

    fill(255);
  }
}
