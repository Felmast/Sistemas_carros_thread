class FloydData{
  int[][] table;
  int[][] path;
}

void setup(){
  //EXAMPLE
  int[][] table = new int[8][8];
  for(int i = 0; i < table.length; i++){
    for(int j = 0; j < table.length; j++){
      table[i][j] = 99999;
      if(i == j)
        table[i][j] = 0;
    }
  }
  table[0][3] = 3;
  table[3][6] = 4;
  
  FloydData fd = floyd(table);
  
  println("\nResult Table:");
  printTable(fd.table);
  println("\nPath:");
  printTable(fd.path);
  
  println("\n\nPath from 0 to 6:");
  printArray(get_path(fd,0,6));
  
  noLoop();
  exit();
}

FloydData floyd(int[][] d0){
  int[][][] tables = new int[d0.length][d0.length][d0.length];
  int[][] p_table = new int[d0.length][d0.length];
  
  for(int i=0; i < d0.length; i++){
    for(int j=0; j < d0.length; j++){
      for(int k=0; k < d0.length; k++){
        if(i == 0){
          p_table[j][k] = -1;
          if(d0[j][k] != -1 && d0[j][k] < 99999){
            p_table[j][k] = j;
          }
          tables[0][j][k] = d0[j][k];
        }else{
          if(j == i || k == i)
          {
            tables[i][j][k] = tables[i-1][j][k];
          }
          else if(j == k)
          {
            p_table[j][k] = j;
          }
          else
          {
            tables[i][j][k] = min(tables[i-1][j][k], tables[i-1][i][k] + tables[i-1][j][i]);
            if(tables[i][j][k] != tables[i-1][j][k]){
              p_table[j][k] = i;
            }
          }
        }
      }
    }
  }
  
  FloydData fd = new FloydData();
  fd.table = tables[3];
  fd.path = p_table;
  return fd;
}

int[] get_path(FloydData fd, int node1, int node2){
  int[] path = new int[fd.table.length];
  int pos = fd.table.length-1;
  path[0] = -1;
  
  path[pos--] = node2;
  if(fd.path[node1][node2] == -1 || fd.path[node1][node2] > 99999){
      path[pos--] = -1;
  }else{
    node2 = fd.path[node1][node2];
    while(node2 != node1){
      path[pos--] = node2;
      node2 = fd.path[node1][node2];
    }
  }
  path[pos] = node1;
  
  int c = 0;
  for(int i = fd.table.length - pos + 1; c < fd.table.length; c++){
    i++;
    if(i < fd.table.length){
      path[c] = path[i];
    }else{
      path[c] = -1;
    }
  }
  
  return path;
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

void draw(){

}
