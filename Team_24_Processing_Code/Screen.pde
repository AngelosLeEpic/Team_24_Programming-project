class Screen
{

  Screen(int w, int h) {
    TAB_WIDTH =  (int)(width * 0.260416);
    TAB_BORDER_WIDTH =  (int)(width * 0.010416);
    HEIGHT_B = (int)(height * 0.04629);
    WIDTH_B = (int)(width * 0.078123);
  }

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
  int TAB_WIDTH;
  int TAB_BORDER_WIDTH;

  int numberOfPages, numberOfGraphs; // The amount of pages that the user can flick through based on the amount of data that needs to be displayed
  int selectedPage = 1;
  int dataBlockYMargin = 5;
  // Layout of buttons and drop down menus
  int HEIGHT_B;
  int WIDTH_B;

  // drop down buttons
  int NUMBER_OF_DROPDOWNS = 5;

  void renderDIP() {
    renderUpperTab();
    fill(PRIMARY_COLOR);
    rect(0, 0, TAB_WIDTH, displayHeight);
    fill(SECONDARY_COLOR);
    rect(TAB_WIDTH, 0, TAB_BORDER_WIDTH, displayHeight);

    fill(TEXT_COLOR);
    textFont(headingFont);
    text("DATE", (int)(width * 0.052083), (int)(height * 0.055555));
    text("TIME", (int)(width * 0.052083), (int)(height * 0.2037037));
    text("AIRPORT", (int)(width * 0.052083), (int)(height * 0.4629));

    textFont(TextBoxFont);
    text("BETWEEN:", 25, (int) (height * 0.1) + (HEIGHT_B/2));
    text("DEPARTURE:", 25, (int) (height * 0.25) + (HEIGHT_B/2));
    text("ARRIVAL:", 25, (int) (height * 0.35) + (HEIGHT_B/2));
    text("ARRIVES TO:", 25, (int) (height * 0.52) + (HEIGHT_B/2));
    text("DEPARTS FROM:", 25, (int) (height * 0.6) + (HEIGHT_B/2));
  }
  void renderUpperTab() {
    fill(PRIMARY_COLOR);
    rect(0, 0, width, (int)(height/10));
    stroke(TERTIARY_COLOR);
    strokeWeight(5);
    for (int i = 0; i < TabButtons.size(); i++)
    {
      TabButtons.get(i).render();
    }
    strokeWeight(0);
  }
  void renderButtons()
  {
    for (int i = 0; i < textBoxList.size(); i++)
    {
      textBoxList.get(i).render();
    }
    for (int i = 0, n = buttonList.size(); i < n; i++)
    {
      buttonList.get(i).render();
    }
    for (int i = 0; i < dropDownList.size(); i++)
    {
      dropDownList.get(i).render();
    }
    startDate.render();
    endDate.render();
  }
  // Renders all the filtered datapoints, if the list of data points is not null that is
  void renderTab1()
  {
    fill(SECONDARY_COLOR);
    rect(0, 0, (int)(width * 0.18232916), (int)(height * 0.037037),0,0,20,0);
    textSize(20);
    fill(TEXT_COLOR);
    if (filteredData != null && filteredData.size() != 0)
    {
      text("Displaying flights: " + filteredData.size(), 10, 20);
      int dataBlockWidth =((width - TAB_WIDTH - TAB_BORDER_WIDTH) / 2) - 10;
      int dataBlockHeigh =(int)((float)height / (float)6.5);
      int dataBlockYMove = dataBlockHeigh + 5;
      int dataBlockYpos = height / 10 + 10;

      int temp = 0;
      for (int i = 0; i < 10; i++)
      {
        try {
          if (i < 5)
          {
            renderDataBock(TAB_WIDTH + TAB_BORDER_WIDTH + 20 + temp, dataBlockYpos + dataBlockYMove * i, dataBlockWidth, dataBlockHeigh, filteredData.get(i+(selectedPage - 1) * 10));
          } else
          {
            renderDataBock(TAB_WIDTH + TAB_BORDER_WIDTH + 20 + 10 + dataBlockWidth, dataBlockYpos + dataBlockYMove * (i-5), dataBlockWidth, dataBlockHeigh, filteredData.get(i+(selectedPage - 1) * 10));
          }
        }
        catch(Exception e)
        {
          break; // This means we tried accessing elements outisde of the array, we run out of elements to display
        }
      }
    } else
    {
      text("No flights displayed", 10, 20);
    }
  }
  void renderDataBock(int xpos, int ypos, int w, int h, DisplayDataPoint D) {
    textSize(30);
    fill(TERTIARY_COLOR);
    rect(xpos, ypos, w, h, 10);
    fill(TEXT_COLOR);
    text("Arrivals: " + D.ORIGIN, xpos, ypos + h / 10);
    text("Destination: " + D.DEST, xpos, ypos + h/2);

    if (D.CANCELLED == 0 && D.DIVERTED == 0)
    {
      text("Time: " + D.ARR_TIME, xpos, ypos + h / 10 * 3);
      text("Time: " + D.DEP_TIME, xpos, ypos + h/2 + h/4);
    } else if (D.DIVERTED == 1 && D.CANCELLED == 0)
    {
      text("Time: " + D.ARR_TIME, xpos, ypos + h / 10 * 3);
      text("Time: " + D.DEP_TIME, xpos, ypos + h/2 + h/4);
      fill(BUTTON_OFF);
      text("DIVERTED", xpos+ w/2, ypos + h / 2);
    } else
    {
      fill(BUTTON_OFF);
      text("CANCELLED", xpos+ w/2, ypos + h / 2);
    }
    fill(TEXT_COLOR);
    if(nameToLogo(D.MKT_CARRIER) != null)
    {
      text("Carrier: " + D.MKT_CARRIER, xpos + w/2, ypos + h / 10);
      image(nameToLogo(D.MKT_CARRIER), xpos + w/1.2,ypos + h / 2.5, (int)(width * 0.02604 * 2), (int)(height * 0.04629 * 2));
    } else {
      text("Carrier: " + D.MKT_CARRIER, xpos + w/2, ypos + h / 10);
    }
    text("Date: " + D.FL_DATE, xpos + w/2, ypos + h / 10 *3);
  }
  QueriesSelect queries = new QueriesSelect();

  void renderTab2()
  { 
    textAlign(CENTER,CENTER);
    textFont(headingFont);
    switch(displayedGraph)
    {
    case 0:
      text("FLIGHT EXPECTANCY", (displayWidth+TAB_WIDTH)/2, height*0.16);
      textFont(TextBoxFont);
      graphP.drawPieChart(valuesP);
      break;
    case 1:
      text("FLIGHTS PER CARRIER", (displayWidth+TAB_WIDTH)/2, height*0.16);
      textFont(TextBoxFont);
      graphB1.drawBarChart(valuesB1);
      break;
    case 2:
    text("FLIGHTS PER HOUR", (displayWidth+TAB_WIDTH)/2, height*0.16);
    textFont(TextBoxFont);
      //graphS.draw(valuesDS);
      break;
    case 3:
      text("DISTANCE PER CARRIER", (displayWidth+TAB_WIDTH)/2, height*0.16);
      textFont(TextBoxFont);
      graphB2.drawBarChart(valuesB2);
      break;
    case 4:
      text("HEATMAP OF ROUTES", (displayWidth+TAB_WIDTH)/2, height*0.16);
      textFont(TextBoxFont);
      graphD.draw(valuesA, valuesDS);
      break;
    case 5:
      text("AVERAGE TIME DELAY PER CARRIER (MIN)", (displayWidth+TAB_WIDTH)/2, height*0.16);
      textFont(TextBoxFont);
      graphT.draw(valuesT);
    default:
      //println("No graph found");
      break;
    }
  }
  
  void renderTab3()
  {
    graphA.update(); // Update node positions and check for collisions
    graphA.draw();
    
    graphA.displayHoveredNodeLabel();
    graphA.displaySelectedAirportData();
  }

  void pageSelectButtons()
  {
    if (moveLeft.isClicked())
    {
      switch(currentlyActiveTab)
      {
      case 0:
        screen.selectedPage--;
        if (screen.selectedPage <= 0)
          screen.selectedPage = 1;
        break;
      case 1:
        displayedGraph--;
        if (displayedGraph < 0)
          displayedGraph = numberOfGraphs - 1;
        break;
      default:
        println("No function");
        break;
      }
    }

    if (moveRight.isClicked())
    {
      switch(currentlyActiveTab)
      {
      case 0:
        screen.selectedPage++;
        if (screen.selectedPage > screen.numberOfPages)
          screen.selectedPage = screen.numberOfPages;
        break;
      case 1:
        displayedGraph++;
        if (displayedGraph >= numberOfGraphs)
          displayedGraph = 0;
        break;
      default:
        println("No function");
        break;
      }
    }
  }

  void changeTheme(THEMES selectedTheme)
  {
    switch (selectedTheme)
    {
    case GIRLBOSS:
      PRIMARY_COLOR = color(255, 5, 164);
      SECONDARY_COLOR = color(255, 176, 226);
      TERTIARY_COLOR = color(216, 0, 170);
      BACKGROUND = color(255, 0, 149);
      BUTTON_ON = color(201, 0, 54);
      BUTTON_OFF = color(57, 0, 33);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case BOYBOSS:
      PRIMARY_COLOR = color(31, 31, 31);
      SECONDARY_COLOR = color(70, 69, 129);
      TERTIARY_COLOR = color(40, 39, 113);
      BACKGROUND = color(134, 134, 203);
      BUTTON_ON = color(2, 0, 157);
      BUTTON_OFF = color(1, 0, 100);
      TEXT_COLOR = color(255);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case DAY:
      PRIMARY_COLOR = color(162, 248, 255);
      SECONDARY_COLOR = color(57, 240, 255);
      TERTIARY_COLOR = color(0, 174, 188);
      BACKGROUND = color(150, 266, 222);
      BUTTON_ON = color(0, 236, 255);
      BUTTON_OFF = color(44, 111, 116);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case DUSK:
      PRIMARY_COLOR = color(34, 32, 113);
      SECONDARY_COLOR = color(67, 31, 93);
      TERTIARY_COLOR = color(53, 19, 98);
      BACKGROUND = color(84, 50, 113);
      BUTTON_ON = color(75, 21, 124);
      BUTTON_OFF = color(35, 0, 67);
      TEXT_COLOR = color(255);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case COSMIC:
      PRIMARY_COLOR = color(90, 3, 255);
      SECONDARY_COLOR = color(129, 83, 216);
      TERTIARY_COLOR = color(140, 83, 216);
      BACKGROUND = color(83, 104, 216);
      BUTTON_ON = color(30, 25, 224);
      BUTTON_OFF = color(3, 0, 124);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case RUST:
      PRIMARY_COLOR = color(149, 137, 134);
      SECONDARY_COLOR = color(108, 96, 94);
      TERTIARY_COLOR = color(165, 137, 132);
      BACKGROUND = color(116, 88, 88);
      BUTTON_ON = color(255);
      BUTTON_OFF = color(57, 49, 49);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case MARINE:
      PRIMARY_COLOR = color(10, 88, 129);
      SECONDARY_COLOR = color(25, 112, 157);
      TERTIARY_COLOR = color(76, 156, 198);
      BACKGROUND = color(81, 178, 229);
      BUTTON_ON = color(0, 168, 255);
      BUTTON_OFF = color(2, 67, 100);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case STELLAR:
      PRIMARY_COLOR = color(225, 237, 60);
      SECONDARY_COLOR = color(254, 255, 10);
      TERTIARY_COLOR = color(252, 252, 148);
      BACKGROUND = color(242, 242, 42);
      BUTTON_ON = color(255, 255, 191);
      BUTTON_OFF = color(116, 116, 64);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(150);
      break;
    case COLOURBLIND:
      PRIMARY_COLOR = color(160);
      SECONDARY_COLOR = color(118);
      TERTIARY_COLOR = color(90);
      BACKGROUND = color(193);
      BUTTON_ON = color(255);
      BUTTON_OFF = color(0);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(150);
      break;
    default:
      PRIMARY_COLOR = color(0, 50, 100);
      SECONDARY_COLOR = color(200, 200, 255);
      TERTIARY_COLOR = color(100, 200, 200);
      BACKGROUND = color(230, 230, 230);
      BUTTON_ON = color(100, 250, 100);
      BUTTON_OFF = color(250, 100, 100);
      TEXT_COLOR = color(0);
      INACTIVE_TEXT_BOX = color(255);
      break;
    }
  }
}
