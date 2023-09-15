ArrayList<Car> cars = new ArrayList();

class Car {
  float distanceBetween = 0;
  float distanceTravelled = 0;
  int[] path;
  float speed = 10;
  float cspeed = 10;
  int currNodeIndex = -1;
  FloydData fd;

  int begin;
  int end;

  float deltaTime = 1;

  Car() {
  }

  Car(int startNode, FloydData fd, List<int[][]> validPaths) {
    int nodes = fd.table.length;
    this.fd = fd;

    Random random = new Random();
    end = startNode;
    
    if(validPaths.size() == 0){
      forceEnd();
      return;
    }
    
    int[][] selectedPath = validPaths.get(random.nextInt(validPaths.size()));
    
    
    path = selectedPath[1];
    end = selectedPath[0][0];
    
    nextNode();
    println("Chosen Path: ");printArray(path);
  }

  void advance() {
    distanceTravelled += cspeed * deltaTime;
    distanceTravelled = distanceTravelled > distanceBetween? distanceBetween : distanceTravelled;
  }

  void stop() {
    cspeed = 0;
  }

  void start() {
    cspeed = speed;
  }

  void nextNode() {
    currNodeIndex++;
    
    if (currNodeIndex+1 >= path.length || path[currNodeIndex] == -1 || path[currNodeIndex+1] == -1) {
      forceEnd();
      return;
    }

    distanceTravelled = 0;
    distanceBetween = fd.baseTable[path[currNodeIndex]][path[currNodeIndex + 1]];
  }

  void forceEnd() {
    currNodeIndex = currNodeIndex >= path.length? path.length-1 : currNodeIndex;
    path[currNodeIndex] = end;
  }

  boolean atEnd() {
    return path[currNodeIndex] == end;
  }

  boolean atDistanceEnd() {
    return distanceTravelled >= distanceBetween;
  }

  int getCurrentNode() {
    return path[currNodeIndex];
  }

  void setDeltaTime(float t) {
    deltaTime = t;
  }

  float getTravelledPercentage() {
    return distanceTravelled/distanceBetween;
  }
}



class VehicleGenerator extends Thread {
  int node;
  float alpha;
  FloydData fd;

  VehicleGenerator(int ni, float al, FloydData fd) {
    node = ni;
    alpha = al;
    this.fd = fd;
  }

  public void run() {
    generateVehicles(node, alpha, fd);
  }


  void generateVehicles(int node, float alpha, FloydData fd) {
    //function that receives the index of a node and generates the vehicles from it
    
    List<int[][]> validPaths = new ArrayList();
    for(int i=0; i<fd.table.length; i++){
      if(i != node && fd.path[node][i] != -1){
        int[][] t = {{i},get_path(fd, node, i)};
         validPaths.add(t);
      }
    }
    
    if(alpha <= 0 || validPaths.size() == 0){
      return;
    }

    long startTime = System.currentTimeMillis();
    Timer timer = new Timer();

    timer.scheduleAtFixedRate(new TimerTask() {
      @Override
        public void run() {

        carListLock.lock();
        try {
          cars.add(new Car(node, fd, validPaths));
           thread("moveCar");
        }
        finally {
          carListLock.unlock();
        }

        if (!inSimulation) {
          timer.cancel();
        }
      }
    }
    , 0, (long) (1000/alpha));
  }
}

//AVERAGE SPEED_____________________________________________________________________________________________________________________________
float averageSpeed() {
  float sum = 0;
  for (Car car : cars)
    sum += car.cspeed;
  return sum / (float)cars.size();
}


//CAR THREAD_____________________________________________________________________________________________________________________________
int frameMillis = (int)(1.0/60.0 * 1000);
ReentrantLock carListLock = new ReentrantLock();
void moveCar() {
  int currCar = cars.size() - 1;
  Car car = cars.get(currCar);

  car.setDeltaTime(1.0/60.0); // 1 / frames per second

  while (car != null && inSimulation && !car.atEnd()) {
    car.advance();
    if (car.atDistanceEnd()) {
      //Here goes the node lock
      car.nextNode();
      car.stop();
      if (!car.atEnd()) {
        ReentrantLock occupied = nodesState.get(car.getCurrentNode());
        occupied.lock();
        try {
          println("I'm at node: " + car.getCurrentNode());
          delay(2000);
        }
        catch(Exception e) {
        }
        finally {
          occupied.unlock();
          car.start();
        }
      }
    }
    
    if (car.atEnd()) {
      car.stop();
      carListLock.lock();
      try {
        cars.remove(car);
      }
      finally {
        carListLock.unlock();
      }
      car = null;
      break;
    }

    //println("moving... "+String.format("%.2f",car.getTravelledPercentage())+"%");
    delay(frameMillis); //Cars don't move each frame because they are a thread, so it needs tobe delayed to an arbitrary number of frames/second
  }
  
  if (car != null && !inSimulation) {
      car.stop();
      carListLock.lock();
      try {
        cars.remove(car);
      }
      finally {
        carListLock.unlock();
      }
      car = null;
    }
}
