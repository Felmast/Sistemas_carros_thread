class FloydData{
  int[][] table;
  int[][] path;
}

void setup(){
  int[][] table = {
    {0,1,2,3,4,5,6,7},
    {1,0,2,3,4,5,6,7},
    {2,2,0,3,4,5,6,7},
    {3,3,3,0,4,5,6,7},
    {0,1,2,3,0,5,0,7},
    {1,6,2,3,4,0,6,9},
    {2,2,7,3,4,5,0,7},
    {3,3,3,80,4,5,6,0}
  };
  
  FloydData fd = floyd(table);
  
  println("\nResult Table:");
  printTable(fd.table);
  println("\nPath:");
  printTable(fd.path);
  
  noLoop();
  exit();
}

FloydData floyd(int[][] d0){
  int[][][] tables = new int[d0.length][d0.length][d0.length];
  
  for(int i=1; i < d0.length; i++){
    for(int j=0; j < d0.length; j++){
      for(int k=0; k < d0.length; k++){
        if(i == 1){
          tables[0][j][k] = d0[j][k];
        }
        if(j == i || k == i)
        {
          tables[i][j][k] = tables[i-1][j][k];
        }
        else
        {
          tables[i][j][k] = min(tables[i-1][j][k], tables[i-1][i][k] + tables[i-1][j][i]);
          if(tables[i][j][k] != tables[i-1][j][k]){
            tables[0][j][k] = i;
          }
        }
      }
    }
  }
  
  FloydData fd = new FloydData();
  fd.table = tables[3];
  fd.path = tables[0];
  return fd;
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

void draw(){

}
