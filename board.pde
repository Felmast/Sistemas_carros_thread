class board {
  int currentTool = 0;
  int action = 0;
  path p ;
  boolean mouseOnStart = false;
  boolean mouseOnCreate = false;
  boolean mouseOnDelete = false;
  boolean mouseOnConnect = false;
  boolean setDistance = false;
  boolean complete = false;
  String inputDistance = "";
  board() {
  }
  void drawSimuBoard() {
    rect(50, 52, 1150, 750, 28); //simulation board
    if (simulationOn)
      fill(#D1D3D1);
    strokeWeight(2);
    if (mouseOnCreate)
      fill(#F0EBEB);

    rect(50, 52, 100, 100, 28, 0, 0, 0); //Create tool
    strokeWeight(1);
    circle(100, 100, 80); // circle tool

    if (!simulationOn)
      fill(255);
    strokeWeight(3);

    if (mouseOnDelete)
      fill(#F0EBEB);

    rect(50, 152, 100, 100); //Delete tool
    if (!simulationOn)
      fill(255);

    if (mouseOnConnect)
      fill(#F0EBEB);

    rect(50, 252, 100, 100); //Conect tool
    if (!simulationOn)
      fill(255);

    stroke(#FF1212);
    int x = 70;
    int y = 130;
    line(x, 230, y, 170);
    line(x, 170, y, 230);
    strokeWeight(3);
    stroke(0);
    line(70, 270, 130, 340);
    strokeWeight(1);
  }

  void drawBottonsText() {
    fill(#F0EBEB);  //Color statistics
    rect(50, 855, 250, 50);  //simulation time
    rect(350, 855, 250, 50); //number of cars
    rect(650, 855, 250, 50); //average speed
    fill(0); //Color black
    textSize(20);

    long mins;
    long secs;
    if (inSimulation) {
      actualTimer = millis() - startTime;
      long time =  millis() - startTime;
      mins = time / 60000;
      secs = (time - mins * 60000) / 1000;
    } else {
      mins = actualTimer / 60000;
      secs = (actualTimer - mins * 60000) / 1000;
    }
    text("Simulation time: " +mins + ":" + String.format("%02d", secs), 60, 888);
    text("Number of cars: " + cars.size(), 360, 888);
    text("Average speed: " + String.format("%.2f", averageSpeed()), 665, 888);

    textSize(30);
    if (!simulationOn) {
      if (!mouseOnStart)
        fill(#8EE58D); //Color Start simulation
      else
        fill(#71A770); //Color Start simulation
      rect(950, 855, 250, 50); //Start simulation
      fill(0); //Color black
      text("Start Simulation", 975, 890);
    } else {
      if (!mouseOnStart)
        fill(#FF1212); //Color end simulation
      else
        fill(#CE0408);
      rect(950, 855, 250, 50); //end simulation
      fill(0); //Color black
      text("Stop Simulation", 975, 890);
    }

    fill(255); //Color white
  }

  void useTool() {
    if (action != 0) {
      switch(currentTool) {

      case 0:
        break;

      case 1:
        nodes.add(new node(mouseX, mouseY, 80));
        action = 0;
        currentTool = 0;
        break;

      case 2:
        node ref = null;
        List<path> path_ref = new ArrayList<path>();
        int index = -1;
        for (int i =0; i < nodes.size(); i++ ) {
          if (nodes.get(i).getNode() != null) {
            ref = nodes.get(i).getNode();
            index = i;
          }
        }
        for (int i =0; i < paths.size(); i++ ) {
          if (paths.get(i).getNode1() == index || paths.get(i).getNode2() == index ) {
            path_ref.add(paths.get(i).getPath());
          }
        }
        for (path p : path_ref) {
          paths.remove(p);
        }
        
         for (path p : paths) {
            if (p.indiceNodo1 > index)
              p.indiceNodo1 =  p.indiceNodo1-1;
            if (p.indiceNodo2 > index)
              p.indiceNodo2 =  p.indiceNodo2-1;
        }
        
        nodes.remove(ref);
        for (int i =0; i < paths.size(); i++ ) {
          print(paths.get(i).indiceNodo1 + " "+ paths.get(i).indiceNodo2 +" " +paths.get(i).value + "\n" );
        }
        action = 0;
        currentTool = 0;
        break;

      case 3:
        if (action == 1 && complete) {
          if (!inputDistance.equals("") && !inputDistance.equals("0")) {
            p.setValue(int(inputDistance));
            paths.add(p);

            setDistance = false;
            p = null;
            inputDistance = "";
            complete = false;
          }
        }
        if (action == 2) {
          for (int i =0; i < nodes.size(); i++ ) {
            node n = nodes.get(i);
            if (n.getNode() != null) {
              p.setNode2(n.x, n.y, i);
              setDistance = true;
              action = 1;
            }
          }
        }
        if (action == 3) {
          for (int i =0; i < nodes.size(); i++ ) {
            node n = nodes.get(i);
            if (n.getNode() != null) {
              p = new path();
              p.setNode1(n.x, n.y, i);
              action = 2;
            }
          }
        }
        break;

      default:
        break;
      }
    }
  }

  void setDistance() {
    int x = 50;
    int y = 352;
    textSize(18);
    fill(255);
    strokeWeight(3);
    rect(x, y, 100, 100);
    rect(x, y+25, 100, 100);
    strokeWeight(1);
    fill(0);
    text("Set distance ", x+5, y+20); //average speed
    text(inputDistance, x+25, y+70); //average speed
    fill(255);
  }

  void mousePressed() {
    if (mouseX>=950 && mouseX <=1200 && mouseY>=855 && mouseY<=955) {
      simulationOn = !simulationOn;
      inSimulation = !inSimulation;
      if (simulationOn)
        startSimulation();
    }
    if (!simulationOn && mouseX>=50 && mouseX <=150 && mouseY>=52 && mouseY<=152) { //Select create tool
      currentTool = 1;
      action = 1;
    }
    if (!simulationOn && mouseX>=50 && mouseX <=150 && mouseY>=153 && mouseY<=253) { //Select delete tool
      currentTool = 2;
      action = 1;
    }

    if (!simulationOn && mouseX>=50 && mouseX <=150 && mouseY>=254 && mouseY<=354) { //Select connect tool
      currentTool = 3;
      action = 3;
    }

    if (!simulationOn && mouseX>=50 && mouseX <=150 && mouseY>=355 && mouseY<=480) {
      complete = true;
      useTool();
      print(mouseX +" "+ mouseY + "\n");
    }

    if (!simulationOn && mouseX>=151 && mouseX <=1200 && mouseY>=52 && mouseY<=803) { // use tool
      useTool();
    }

    for (node node : nodes) {
      node.mousePressed();
    }
  }

  void mouseMoved() {
    if ( mouseX>=950 && mouseX <=1200 && mouseY>=855 && mouseY<=955)
      mouseOnStart = true;
    else
      mouseOnStart = false;
    if (!simulationOn && mouseX>=50 && mouseX <=150 && mouseY>=52 && mouseY<=152)  //Select create tool
      mouseOnCreate = true;
    else
      mouseOnCreate = false;
    if (  !simulationOn && mouseX>=50 && mouseX <=150 && mouseY>=153 && mouseY<=253)  //Select delete tool
      mouseOnDelete = true;
    else
      mouseOnDelete = false;
    if (!simulationOn && mouseX>=50 && mouseX <=150 && mouseY>=254 && mouseY<=354)  //Select connect tool
      mouseOnConnect = true;
    else
      mouseOnConnect = false;
  }


  void keyPressed() {
    if (setDistance) {
      if (key >= '0' && key <= '9')
        inputDistance += key;
    }
    for (node node : nodes) {
      node.keyPressed();
    }
    print(inputDistance+" ");
  }

  ////////////////////////////////////
  void draw() {
    drawSimuBoard();
    drawBottonsText();
    if (setDistance)
      setDistance();
    for (path p : paths)
      p.draw();
    for (node node : nodes)
      node.draw();
  }
}
