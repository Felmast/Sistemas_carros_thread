class board {
    int currentTool = 0;
    int action = 0;
    board(){}
    
    void drawSimuBoard(){
      rect(50,52,1150,750); //simulation board
      rect(50,52,100,750); //tool Palette
      circle(100,150,80); // circle tool
    }
    
    void drawBottonsText(){
      fill(#D1D3D1);  //Color statistics 
      rect(50,855,250,50);  //simulation time 
      rect(350,855,250,50); //number of cars 
      rect(650,855,250,50); //average speed
      fill(#8EE58D); //Color Start simulation
      rect(950,855,250,50); //tart simulation
      fill(0); //Color black
      textSize(20);
      text("Simulation time:", 60,888);
      text("Number of cars:",360,888);
      text("Average speed:",665,888);
      textSize(30);
      text("Start Simulation",975,890);
      fill(255); //Color white
    }
    
    void useTool(){
      if(action != 0){
        switch(currentTool){
          case 0:
          break;
          case 1:
            nodes.add(new node(mouseX,mouseY,80));
            action = 0;
            currentTool = 0;
          break;
          default:
          break;
        }
      }
    }
    

    void mousePressed() {
      if(allowMP && mouseX>=950 && mouseX <=1200 && mouseY>=855 && mouseY<=955){
        print("Should start the simulation\n");
        allowMP = false;
      }
      if(allowMP && mouseX>=60 && mouseX <=140 && mouseY>=110 && mouseY<=190){
        currentTool = 1;
        action = 1;
         

        allowMP = false; 
      }
      if(allowMP && mouseX>=150 && mouseX <=1200 && mouseY>=52 && mouseY<=803){
          useTool();
          allowMP = false; 
      }
    }
}
  
