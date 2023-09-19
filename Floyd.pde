FloydData floyd(int[][] d0) {
  int[][][] tables = new int[d0.length][d0.length][d0.length];
  int[][] p_table = new int[d0.length][d0.length];
  pathsCache = new int[d0.length][d0.length][d0.length];
  pathsCache[0][0] = null;

  for (int i=0; i < d0.length; i++) {
    for (int j=0; j < d0.length; j++) {
      pathsCache[i][j] = null;
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

int[][][] pathsCache;
int[] get_path(FloydData fd, int node1, int node2) {
  if (pathsCache[node1][node2] != null) {
    return pathsCache[node1][node2];
  }
  int origNode2 = node2;

  if (fd.table.length == 1) {
    int[] p = {0};
    return p;
  }

  int[] path = new int[fd.table.length];
  int pos = fd.table.length-1;
  path[0] = -1;

  path[pos] = node2;
  pos--;
  if (fd.path[node1][node2] == -1) {
    path[pos] = -1;
  } else {
    node2 = fd.path[node1][node2];
    while (node2 != node1 && node2 != -1) {
      path[pos--] = node2;
      node2 = fd.path[node1][node2];
    }
    path[pos] = node1;
  }

  int c = 0;
  int[] newPath  = new int[fd.table.length];
  for (int i = pos; i < fd.table.length; i++) {
    newPath[c++] = path[i];
  }

  pathsCache[node1][origNode2] = newPath;
  return newPath;
}
