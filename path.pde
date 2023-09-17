class path {
  int x_node1;
  int y_node1;
  int x_node2;
  int y_node2;
  int value;
  int indiceNodo1;
  int indiceNodo2;
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

  void draw() {
    strokeWeight(3);
    stroke(0);
    line(x_node1, y_node1, x_node2, y_node2);
    strokeWeight(1);
    textSize(20);
    
    rect((x_node1+x_node2)/2, (y_node1+y_node2)/2,40,23);
    fill(0);
    text(value, (x_node1+x_node2+5)/2, (y_node1+y_node2+35)/2);
    fill(255);
  }
}
