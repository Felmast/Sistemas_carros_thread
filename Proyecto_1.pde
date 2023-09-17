import processing.javafx.*;

import java.util.Timer;
import java.util.TimerTask;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.Random;

import java.util.concurrent.locks.ReentrantLock;

long startTime;
long actualTimer;
boolean inSimulation = false; // Set to true on "Start Simulation"
List<ReentrantLock> nodesState;
boolean allowMP = true;
int n;
float[] alphas; 

int[][] baseTable; 

//Interface
PImage img;
board table;
List<node> nodes;
List<path> paths;
boolean locked = false;
boolean simulationOn = false;

//baseTable[p.indiceNodo1][p.indiceNodo2] = p.value;
//baseTable[p.indiceNodo2][p.indiceNodo1] = p.value;


class FloydData {
  int[][] table;
  int[][] baseTable; //aristas
  int[][] path;
}

void setup() {
  img = loadImage("1.jpg");
  size(1250, 950);
  background(#E5E5E5);
  table = new board();
  nodes = new ArrayList<node>();
  paths = new ArrayList<path>();
  nodesState = new ArrayList();
  //EXAMPLE
//  ejemploSimulacion();
}


void draw() {
  image(img, 0, 0, width, height);
  table.draw();

  
}

void mousePressed() {
  table.mousePressed();
  print("x: " + mouseX + " y: " + mouseY + "\n");
}


void mouseReleased() {
  locked = false;
}

void mouseMoved() {
  table.mouseMoved();
}

void keyPressed() {
  table.keyPressed();
}


void printArray(int[] array) {
  print("[ ");
  for (int k=0; k < array.length; k++) {
    print(array[k]);
    if (k != array.length-1)
      print(" | ");
  }
  println(" ] ");
}

void printTable(int[][] table) {
  for (int j=0; j <table.length; j++) {
    print("[ ");
    for (int k=0; k < table.length; k++) {
      print(table[j][k]);
      if (k != table.length-1)
        print(" | ");
    }
    println(" ] ");
  }
}

void startSimulation() {
  //crear los nodos
  n = 8;

  for (int i = 0; i < n; i++) {
    nodesState.add(new ReentrantLock());
  }

  print(nodes.size());
  //crear los alphas
  alphas = new float[nodes.size()];
  for(int i = 0; i< nodes.size(); i++){
    alphas[i] = nodes.get(i).creationRate;
  }
  
  printArray(alphas);
  baseTable = new int[nodes.size()][nodes.size()];
  
  for(int i = 0; i<nodes.size(); i++){
     for(int j = 0; j<nodes.size(); j++){
      baseTable[i][j] = 99999;
      if(i == j)
         baseTable[i][j] = 0;
    }
  }
  println("paths.size "+paths.size());
  for(int i = 0; i < paths.size(); i++){
    println("i " + i);
    println("paths.get(i).indiceNodo1 " + paths.get(i).indiceNodo1);
    println("paths.get(i).indiceNodo2 " + paths.get(i).indiceNodo2);
    baseTable[paths.get(i).indiceNodo1][paths.get(i).indiceNodo2] = paths.get(i).value;
    baseTable[paths.get(i).indiceNodo2][paths.get(i).indiceNodo1] = paths.get(i).value;
  }
  
  println("paths.size "+paths.size());
  printTable(baseTable);
  FloydData fd = floyd(baseTable);
  startTime = millis();
  println("\nResult Table:");
  printTable(fd.table);
  println("\nPath:");
  printTable(fd.path);

  //println("\n\nPath from 0 to 2:");
  //printArray(get_path(fd,0,2));


  inSimulation = true;
 // print("entrando");
  //por cada nodo generar carritos
  for (int i = 0; i < nodes.size(); i++) {
    VehicleGenerator node = new VehicleGenerator(i, alphas[i], fd);
  //  print("entrando");
    node.run();
  }
}
