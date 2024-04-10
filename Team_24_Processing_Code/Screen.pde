/**
 * Represents the screen layout and theme settings of the application.
 */
class Screen {

  // Constants for screen layout
  int TAB_WIDTH;                  // Width of the tab
  int TAB_BORDER_WIDTH;           // Width of the tab border
  int HEIGHT_B;                   // Height of buttons
  int WIDTH_B;                    // Width of buttons

  // Theme colors
  color PRIMARY_COLOR;            // Primary color
  color SECONDARY_COLOR;          // Secondary color
  color TERTIARY_COLOR;           // Tertiary color
  color BACKGROUND;               // Background color
  color BUTTON_ON;                // Color for active buttons
  color BUTTON_OFF;               // Color for inactive buttons
  color TEXT_COLOR;               // Text color
  color INACTIVE_TEXT_BOX;        // Color for inactive text boxes

  // Variables for database interaction panel (DIP)
  int numberOfPages;              // Number of pages based on the amount of data to be displayed
  int numberOfGraphs;             // Number of graphs to be displayed
  int selectedPage = 1;           // Currently selected page
  int dataBlockYMargin = 5;       // Margin for data blocks

  // Variables for drop-down buttons
  int NUMBER_OF_DROPDOWNS = 5;    // Number of drop-down menus

  /**
   * Constructs a new Screen object and sets initial values for layout constants.
   */
  Screen() {
    // Initialize tab and button dimensions based on screen width and height
    TAB_WIDTH = (int)(width * 0.260416);
    TAB_BORDER_WIDTH = (int)(width * 0.010416);
    HEIGHT_B = (int)(height * 0.04629);
    WIDTH_B = (int)(width * 0.078123);
  }



  /**
   * Renders the Data Input Panel (DIP) of the application interface.
   * This method draws the upper tab, background rectangles, and text labels for date, time, and airport inputs.
   */
  void renderDIP() {
    // Render the upper tab
    renderUpperTab();

    // Set fill color to PRIMARY_COLOR and draw a rectangle on the left side of the DIP
    fill(PRIMARY_COLOR);
    rect(0, 0, TAB_WIDTH, displayHeight);

    // Set fill color to SECONDARY_COLOR and draw a border rectangle on the right side of the DIP
    fill(SECONDARY_COLOR);
    rect(TAB_WIDTH, 0, TAB_BORDER_WIDTH, displayHeight);

    // Set fill color to TEXT_COLOR and render text labels for date, time, and airport inputs
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


  /**
   * Renders the upper tab of the application interface, including tab buttons.
   * This method draws a colored rectangle as the background of the upper tab,
   * renders tab buttons, and sets the stroke weight for tab button outlines.
   */
  void renderUpperTab() {
    // Set fill color to PRIMARY_COLOR and draw a rectangle as the background of the upper tab
    fill(PRIMARY_COLOR);
    rect(0, 0, width, (int)(height/10));

    // Set stroke color to TERTIARY_COLOR and weight to 5 for drawing tab button outlines
    stroke(TERTIARY_COLOR);
    strokeWeight(5);

    // Render each tab button
    for (int i = 0; i < TabButtons.size(); i++) {
      TabButtons.get(i).render();
    }

    // Reset stroke weight to 0 to remove outline for subsequent elements
    strokeWeight(0);
  }

  /**
   * Renders most buttons, text boxes, drop-down lists, and date inputs on the screen.
   * The rendering of some buttons is done seperete to this method
   * This is because some buttons requiere us to have more control on the order by which they are rendered
   */
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
  /**
   * Renders all the filtered data points on Tab 1, if the list of data points is not null.
   * This method specifically renders flights on Tab 1.
   */
  void renderTab1()
  {
    // Set color and draw a rectangle as a background for the flight display
    fill(SECONDARY_COLOR);
    rect(0, 0, (int)(width * 0.18232916), (int)(height * 0.037037), 0, 0, 20, 0);

    // Set text size and color
    textSize(20);
    fill(TEXT_COLOR);

    // Check if filteredData is not null and contains elements
    if (filteredData != null && filteredData.size() != 0)
    {
      // Calculate dimensions for each data block
      text("Displaying flights: " + filteredData.size(), 10, 20);
      int dataBlockWidth =((width - TAB_WIDTH - TAB_BORDER_WIDTH) / 2) - 10;
      int dataBlockHeigh =(int)((float)height / (float)6.5);
      int dataBlockYMove = dataBlockHeigh + 5;
      int dataBlockYpos = height / 10 + 10;

      int temp = 0;

      // Render each data block up to a maximum of 10
      for (int i = 0; i < 10; i++)
      {
        try {
          // Determine the position and size of the data block based on the current page and current column
          if (i < 5)
          {
            renderDataBlock(TAB_WIDTH + TAB_BORDER_WIDTH + 20 + temp, dataBlockYpos + dataBlockYMove * i, dataBlockWidth, dataBlockHeigh, filteredData.get(i+(selectedPage - 1) * 10));
          } else
          {
            renderDataBlock(TAB_WIDTH + TAB_BORDER_WIDTH + 20 + 10 + dataBlockWidth, dataBlockYpos + dataBlockYMove * (i-5), dataBlockWidth, dataBlockHeigh, filteredData.get(i+(selectedPage - 1) * 10));
          }
        }
        catch(Exception e)
        {
          break; // Exit loop if attempting to access elements outside the array, it means we run out of datapoints
        }
      }
    } else
    {
      // If filteredData is null or empty, display a message indicating no flights are displayed
      text("No flights displayed", 10, 20);
    }
  }

  /**
   * Renders a data block representing a flight on the screen.
   * This method displays information such as origin, destination, time, carrier, and date of the flight.
   *
   * @param xpos The x-coordinate of the top-left corner of the data block.
   * @param ypos The y-coordinate of the top-left corner of the data block.
   * @param w    The width of the data block.
   * @param h    The height of the data block.
   * @param D    The DisplayDataPoint object containing information about the flight to be displayed.
   * THIS METHOD MUST NOT BE CALLED INDIVIDUALLY, it is exclusivly called by renderTab1()
   */
  void renderDataBlock(int xpos, int ypos, int w, int h, DisplayDataPoint D) {
    // Set text size and color
    textSize(30);
    fill(TERTIARY_COLOR);

    // Draw rectangle representing the data block
    rect(xpos, ypos, w, h, 10);

    // Set text color
    fill(TEXT_COLOR);

    // Display origin and destination of the flight
    text("Arrivals: " + D.ORIGIN, xpos, ypos + h / 10);
    text("Destination: " + D.DEST, xpos, ypos + h/2);

    // Display arrival and departure times, depending on flight status (cancelled, diverted, or regular)
    if (D.CANCELLED == 0 && D.DIVERTED == 0) {
      text("Time: " + D.ARR_TIME, xpos, ypos + h / 10 * 3);
      text("Time: " + D.DEP_TIME, xpos, ypos + h/2 + h/4);
    } else if (D.DIVERTED == 1 && D.CANCELLED == 0) {
      text("Time: " + D.ARR_TIME, xpos, ypos + h / 10 * 3);
      text("Time: " + D.DEP_TIME, xpos, ypos + h/2 + h/4);
      fill(BUTTON_OFF);
      text("DIVERTED", xpos+ w/2, ypos + h / 2);
    } else
    {
      fill(BUTTON_OFF);
      text("CANCELLED", xpos+ w/2, ypos + h / 2);
    }

    // Display carrier and carrier logo (if available)
    fill(TEXT_COLOR);
    if (nameToLogo(D.MKT_CARRIER) != null) {
      text("Carrier: " + D.MKT_CARRIER, xpos + w/2, ypos + h / 10);
      image(nameToLogo(D.MKT_CARRIER), xpos + w/1.2, ypos + h / 2.5, (int)(width * 0.02604 * 2), (int)(height * 0.04629 * 2));
    } else {
      text("Carrier: " + D.MKT_CARRIER, xpos + w/2, ypos + h / 10);
    }

    // Display flight date
    text("Date: " + D.FL_DATE, xpos + w/2, ypos + h / 10 * 3);
  }
  QueriesSelect queries = new QueriesSelect();
  /**
   * Controls the renderings of all graphs
   * Uses information on which graph is currently selected and renders only that graph
   */
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
    text("FLIGHTS PER ROUTE", (displayWidth+TAB_WIDTH)/2, height*0.16);
    textFont(TextBoxFont);
      graphS.draw(valuesDS);
      break;
    case 3:
      text("CO2 EMMISIONS PER CARRIER (POUNDS)", (displayWidth+TAB_WIDTH)/2, height*0.16);
      textFont(TextBoxFont);
      graphB2.drawBarChart(valuesB2);
      break;
    case 4:
      text("FREQUENCY OF ROUTES", (displayWidth+TAB_WIDTH)/2, height*0.16);
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
  /**
   * Renders the third tab when selected
   * Also commands the third tab to execute its motion calculations every frame
   */
  void renderTab3()
  {
    graphA.update(); // Update node positions and check for collisions
    graphA.draw(); // Render the nodes
    
    graphA.displayHoveredNodeLabel(); // Dispaly data over a node if the user is hovering over it
    graphA.displaySelectedAirportData(); // Display percise data of data point if selected
  }

  /**
   * Controls the behavior of page selection buttons, such as moving to the previous page or selecting a different graph.
   * This method handles button clicks and updates relevant parameters accordingly.
   */
  void pageSelectButtons() {
    // Check if the "moveLeft" button is clicked
    if (moveLeft.isClicked()) {
      // Switch statement to determine the action based on the currently active tab
      switch(currentlyActiveTab) {
      case 0:
        // If the currently active tab is 0 (e.g., for pagination), decrease the selectedPage
        screen.selectedPage--;
        // Ensure selectedPage doesn't go below 1
        if (screen.selectedPage <= 0)
          screen.selectedPage = 1;
        break;
      case 1:
        // If the currently active tab is 1 (e.g., for graph selection), decrease the displayedGraph
        displayedGraph--;
        // Wrap around to the highest index if displayedGraph goes below 0
        if (displayedGraph < 0)
          displayedGraph = numberOfGraphs - 1;
        break;
      default:
        // If the currently active tab is neither 0 nor 1, print a message indicating no function
        println("No function");
        break;
      }
    }

    /**
     * Is Called to check fi the user has clicked a buttons such as to go from one page to another
     * Adjusts the currently selected page accordingly
     */
    if (moveRight.isClicked()) {
      // Switch statement to determine the action based on the currently active tab
      switch(currentlyActiveTab) {
      case 0:
        // If the currently active tab is 0 (e.g., for pagination), increase the selectedPage
        screen.selectedPage++;
        // Ensure selectedPage doesn't exceed the number of pages
        if (screen.selectedPage > screen.numberOfPages)
          screen.selectedPage = screen.numberOfPages;
        break;
      case 1:
        // If the currently active tab is 1 (e.g., for graph selection), increase the displayedGraph
        displayedGraph++;
        // Wrap around to index 0 if displayedGraph exceeds the number of graphs
        if (displayedGraph >= numberOfGraphs)
          displayedGraph = 0;
        break;
      default:
        // If the currently active tab is neither 0 nor 1, print a message indicating no function
        println("No function");
        break;
      }
    }
  }

  /**
   * Changes the color theme of the application based on the selected theme.
   * This method updates various color constants to reflect the chosen theme.
   *
   * @param selectedTheme The theme selected from the THEMES enum.
   */
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
