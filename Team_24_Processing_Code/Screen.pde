class Screen
{
  
Screen(){}

  // THEME-------------------
  
  // DEFAULT COLOR PALLETE
  
  color PRIMARY_COLOR;
  color SECONDARY_COLOR;
  color TERTIARY_COLOR;
  color BACKGROUND; 
  color BUTTON_ON;
  color BUTTON_OFF;
  color TEXT_COLOR;
  color INACTIVE_TEXT_BOX;
  
  int buttonListSize = 0, dropDownListSize = 0, textBoxListSize = 0;
  
  // TAB 1----------------
  
  // Database interaction panel (DIP)
  int TAB_WIDTH = 500;
  int TAB_BORDER_WIDTH = 20;
  
  int numberOfPages; // The amount of pages that the user can flick through based on the amount of data that needs to be displayed
  int selectedPage = 1;
  int dataBlockYMargin = 5;
  // Layout of buttons and drop down menus
  int HEIGHT_B = 70;
  int WIDTH_B = 200;
  

  // drop down buttons
  int NUMBER_OF_DROPDOWNS = 5;
  void renderDIP(){
    renderUpperTab();
    fill(PRIMARY_COLOR);
    rect(0,0,TAB_WIDTH, displayHeight);
    fill(SECONDARY_COLOR);
    rect(TAB_WIDTH,0,TAB_BORDER_WIDTH, displayHeight);
  }
  void renderUpperTab(){
    fill(PRIMARY_COLOR);
    rect(0,0,width, (int)(height/10));
    stroke(TERTIARY_COLOR);
    strokeWeight(5);
    for(int i = 0; i < TabButtons.size(); i++)
    {
      TabButtons.get(i).render();
    }
    strokeWeight(0);
  }
  void renderButtons()
  {
    for(int i = 0; i < textBoxList.size(); i++)
    {
      textBoxList.get(i).render();
    }
    for(int i = 0; i < buttonList.size(); i++)
    {
      buttonList.get(i).render();
    }
    for(int i = 0; i < dropDownList.size(); i++)
    {
      dropDownList.get(i).render();
    }
    startDate.render();
    endDate.render();
  }
  // Renders all the 
  void renderTab1()
  {
    if(filteredData == null || filteredData.size() == 0)
    {
      //do nothing if there is nothing to render in tab 1
    } else 
    {
      int dataBlockWidth =((width - TAB_WIDTH - TAB_BORDER_WIDTH) / 2) - 10;
      int dataBlockHeigh =(int)((float)height / (float)6.5);
      int dataBlockYMove = dataBlockHeigh + 5;
      int dataBlockYpos = height / 10 + 10;
      textSize(20);
      fill(TEXT_COLOR);
      text("Total flights: " + filteredData.size(), 50, 20);
      int temp = 0;
      for(int i = 0; i < 10; i++)
      {        
        try{
          if(i < 5) 
          {
            renderDataBock(TAB_WIDTH + TAB_BORDER_WIDTH + 20 + temp, dataBlockYpos + dataBlockYMove * i, dataBlockWidth, dataBlockHeigh, filteredData.get(i+(selectedPage - 1) * 10));
          } else 
          {
            renderDataBock(TAB_WIDTH + TAB_BORDER_WIDTH + 20 + 10 + dataBlockWidth, dataBlockYpos + dataBlockYMove * (i-5), dataBlockWidth, dataBlockHeigh, filteredData.get(i+(selectedPage - 1) * 10));
          }
        } catch(Exception e)
        {
          break; // This means we tried accessing elements outisde of the array, we run out of elements to display
        }
      }
    }
  }
  void renderDataBock(int xpos, int ypos, int w, int h, DisplayDataPoint D){
    textSize(30);
    fill(TERTIARY_COLOR);
    rect(xpos, ypos, w, h, 10);
    fill(TEXT_COLOR);
    text("Arrivals: " + D.ORIGIN,xpos + 2, ypos + h / 10);
    text("Destination: " + D.DEST,xpos + 2, ypos + h/2);
    
    if(D.CANCELLED != 1)
    {
      text("Time: " + D.ARR_TIME, xpos + 2, ypos + h / 10 * 3);
      text("Time: " + D.DEP_TIME, xpos + 2,ypos + h/2 + h/4);
    } else 
    {
      fill(BUTTON_OFF);
      text("CANCELLED", xpos, ypos + h / 3);
    }
    
    
  }
  void printTable()
  {
    for(int i = 0, n = 20 /*temp length*/; i <n; i++)
    {
      
    }
  }
  
  void hasUserChangedPage(){ // The user clicked a button to chnange pages for the data display in tab 1
  if(moveLeft.isClicked()){
    screen.selectedPage--;
    if(screen.selectedPage <= 0){
      screen.selectedPage = 1;
    }
  }
    if(moveRight.isClicked()){
      screen.selectedPage++;
      if(screen.selectedPage > screen.numberOfPages){
        screen.selectedPage = screen.numberOfPages;
      }
    }
  }
  String adjustDateInput(String dd_mm_yyyy)
  {
    try
    {
      String[] parts = dd_mm_yyyy.split("/");
      String reversedDate = parts[2] + "-" + parts[1] + "-" + parts[0];
      return reversedDate;
    } catch(Exception e)
    {
      println("How did an invalid date input " + dd_mm_yyyy + " make it to adjustDateInput?");
      return null;
    }
  }
  
void changeTheme(THEMES selectedTheme) 
{
  switch (selectedTheme) 
  {
  case DEFAULT:
    System.out.println("Default theme selected");
    PRIMARY_COLOR = color(0,50,100);
    SECONDARY_COLOR = color(200,200, 255);
    TERTIARY_COLOR = color(100, 200, 200);
    BACKGROUND = color(230,230,230); 
    BUTTON_ON = color(100,250,100);
    BUTTON_OFF = color(250,100,100);
    TEXT_COLOR = color(0,0,0);
    INACTIVE_TEXT_BOX = color(255);
    break;
  case GIRLBOSS:
    System.out.println("Girl boss theme selected");
    PRIMARY_COLOR = color(255,150,150);
    SECONDARY_COLOR = color(200,200, 250);
    TERTIARY_COLOR = color(250, 200, 250);
    BACKGROUND = color(255,210,210); 
    BUTTON_ON = color(100,100,250);
    BUTTON_OFF = color(250,150,100);
    TEXT_COLOR = color(25,0,100);
    INACTIVE_TEXT_BOX = color(255,100,100);
    break;
  case BOYBOSS:
    System.out.println("Boy boss theme selected");
    break;
  case DAY:
    System.out.println("Day theme selected");
    PRIMARY_COLOR = color(255,150,150);
    SECONDARY_COLOR = color(100,100, 0);
    TERTIARY_COLOR = color(250, 250, 200);
    BACKGROUND = color(255,255,255); 
    BUTTON_ON = color(100,100,250);
    BUTTON_OFF = color(250,250,100);
    TEXT_COLOR = color(0,25,25);
    INACTIVE_TEXT_BOX = color(100,250,100);
    break;
  case NIGHT:
    System.out.println("Night theme selected");
    break;
  case CUSTOM_THEME:
    System.out.println("Custom theme selected");
    break;
  default:
    System.out.println("Unknown theme selected, error");
    break;
  }
}
}
