FloydData floyd(int[][] d0) {
  int[][][] tables = new int[d0.length][d0.length][d0.length];
  int[][] p_table = new int[d0.length][d0.length];

  for (int i=0; i < d0.length; i++) {
    for (int j=0; j < d0.length; j++) {
      for (int k=0; k < d0.length; k++) {
        if (i == 0) {
          p_table[j][k] = -1;
          if (d0[j][k] != -1 && d0[j][k] < 99999) {
            p_table[j][k] = j;
          }
          tables[0][j][k] = d0[j][k];
        } else {
          if (j == i || k == i)
          {
            tables[i][j][k] = tables[i-1][j][k];
          } else if (j == k)
          {
            p_table[j][k] = j;
          } else
          {
            tables[i][j][k] = min(tables[i-1][j][k], tables[i-1][i][k] + tables[i-1][j][i]);
            if (tables[i][j][k] != tables[i-1][j][k]) {
              p_table[j][k] = i;
            }
          }
        }
      }
    }
  }

  FloydData fd = new FloydData();
  fd.table = tables[d0.length-1];
  fd.baseTable = d0;
  fd.path = p_table;
  return fd;
}

int[] get_path(FloydData fd, int node1, int node2) {
  int length = fd.table.length+2;
  
  if(fd.table.length == 1){
    int[] p = {0};
    return p;
  }
  /*if(fd.table.length == 2){
    int[] p = {node1, fd.path[node1][node2], node2};
    return p;
  }*/
  
  int[] path = new int[fd.table.length];
  int pos = fd.table.length-1;
  path[0] = -1;

  path[pos] = node2;
  //print("p:"+pos+", ");
  pos--;
  if (fd.path[node1][node2] == -1 || fd.path[node1][node2] > 99999) {
    path[pos--] = -1;
    //print("n:"+pos+", ");
  } else {
    node2 = fd.path[node1][node2];
    while (node2 != node1) {
      //print("s:"+pos+", ");
      path[pos--] = node2;
      node2 = fd.path[node1][node2];
    }
  }
  //print("f:"+pos+"\n");
  path[pos] = node1;

  int c = 0;
  for (int i = fd.table.length - (fd.table.length - pos + 1); c < fd.table.length; c++) {
    i++;
    if (i < fd.table.length) {
      path[c] = path[i];
    } else {
      path[c] = -1;
    }
  }

  return path;
}
