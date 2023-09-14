import processing.javafx.*;

import java.util.Timer;
import java.util.TimerTask;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.Random;

import java.util.concurrent.locks.ReentrantLock;

long startTime;
boolean inSimulation = false; // Set to true on "Start Simulation"
board table;
List<node> nodes;
List<ReentrantLock> nodesState;
boolean allowMP = true;
int n;
float[] alphas;

class FloydData{
  int[][] table;
  int[][] baseTable;
  int[][] path;
}

void setup(){
  size(1250,950,FX2D);
  background(#E5E5E5);
  table = new board();
  nodes = new ArrayList<node>();
  nodesState = new ArrayList();
  startTime = millis();
  
  
  
  //EXAMPLE
  ejemploSimulacion();
  
}

void draw(){
  table.drawSimuBoard();
  table.drawBottonsText();
  for(node node:nodes){
    node.drawNodo(); 
  }
  for(node node:nodes){
    node.option(); 
  }
  //println("Average Speed: " + averageSpeed());
  
}

void mouseDragged() {
    for(node node:nodes)  
       node.mouseDragged();
}

void mousePressed() {
  if(allowMP){
    table.mousePressed();
    for(node node:nodes)
      node.mousePressed(); 
  }
  print("x: " + mouseX + " y: " + mouseY + "\n");
}

void mouseReleased() {
  allowMP = true;
}


void printArray(int[] array){
    print("[ ");
    for(int k=0; k < array.length; k++){
        print(array[k]);
        if(k != array.length-1)
          print(" | ");
    }
    println(" ] ");
}

void printTable(int[][] table){
  for(int j=0; j <table.length; j++){
      print("[ ");
      for(int k=0; k < table.length; k++){
          print(table[j][k]);
          if(k != table.length-1)
            print(" | ");
      }
      println(" ] ");
    }
}

void ejemploSimulacion() {
  //crear los nodos
  n = 8;
  
  for(int i = 0; i < n; i++){
    nodesState.add(new ReentrantLock());
  }
  
  //crear los alphas
  alphas = new float[]{0.75, 1, 0.25, 2, 0.5, 1, 0.25, 2};
  
  //crear rutas
  int[][] table = new int[8][8];
  for(int i = 0; i < table.length; i++){
    for(int j = 0; j < table.length; j++){
      table[i][j] = 99999;
      if(i == j)
        table[i][j] = 0;
    }
  }
  table[0][3] = 30;
  table[3][6] = 40;
  
  FloydData fd = floyd(table);
  
  //println("\nResult Table:");
  //printTable(fd.table);
  //println("\nPath:");
  //printTable(fd.path);
  
  //println("\n\nPath from 0 to 6:");
  //printArray(get_path(fd,0,6));
  
  
  inSimulation = true;
  print("entrando");
  //por cada nodo generar carritos
  for (int i = 0; i < nodes.size(); i++) {
    VehicleGenerator node = new VehicleGenerator(i, alphas[i], fd);
    print("entrando");
    node.run();
  }
}
