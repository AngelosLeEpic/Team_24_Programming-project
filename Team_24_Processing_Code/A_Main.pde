// IMPORT FILES
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.regex.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

// THEMES

enum THEMES
{
    DEFAULT,
    GIRLBOSS,
    BOYBOSS,
    DAY,
    DUSK,
    COSMIC,
    RUST,
    MARINE,
    STELLAR,
    COLOURBLIND
}
String themeNames[] = new String[] {"GIRLBOSS", "BOYBOSS", "DAY", "DUSK", "COSMIC", "RUST", "MARINE", "STELLAR", "COLOURBLIND"};
WidgetDropDown ThemeSelection;

// STATIC SETUP VARIABLE
static ArrayList<WidgetTextBox> textBoxList = new ArrayList<WidgetTextBox>();
static ArrayList<WidgetButton> buttonList = new ArrayList<WidgetButton>();
static ArrayList<WidgetDropDown> dropDownList = new ArrayList<WidgetDropDown>();
static ArrayList<WidgetButton> TabButtons = new ArrayList<WidgetButton>(); // Tab buttons are in a separate list to control their render order

static WidgetButton ReloadButton;
static WidgetButton moveLeft;
static WidgetButton moveRight;

static WidgetButton cancelledFlights;
static WidgetButton delayedFlights;
static WidgetButton undisturbedFlights;

PImage reloadButton;
PImage leftButton;
PImage rightButton;

/*
PImage cancelledButton;
PImage delayedButton;
PImage undisturbedButton;*/

PImage carrierAA;
PImage carrierAS;
PImage carrierB6;
PImage carrierG4;
PImage carrierHA;
PImage carrierNK;
PImage carrierWN;
PImage carrierUA;
PImage carrierDL;

// Takes in the name of a carrier and returns the associated image
PImage nameToLogo(String name)
{
  switch(name)
  {
    case "AA":
      return carrierAA;
    case "AS":
      return carrierAS;
    case "B6":
      return carrierB6;
    case "G4":
      return carrierG4;
    case "HA":
      return carrierHA;
    case "NK":
      return carrierNK;
    case "WN":
      return carrierWN;
    case "UA":
      return carrierUA;
    case "DL":
      return carrierDL;
    default:
      return null;
  }
}

static WidgetTextBox startDate;
static WidgetTextBox endDate;
enum WIDGET_TEXT_TYPE {
    TIME,
    DATE
}

// COLORS AND FONTS SETUP
color ON = color(100, 255, 100);
color OFF = color(255, 100, 100);
PFont TextBoxFont, headingFont;

// GLOBAL UI VARIABLES SETUP
Screen screen;
int currentlyActiveTab = 0;
boolean isDropDownActive = false;
int WIDGET_ROUNDNESS = 10;

// STATISTICAL VARIABLES SETUP
static boolean[] statsShown = new boolean[18];
ArrayList<DisplayDataPoint> filteredData;

// GRAPH DECLERATIONS

ArrayList<PieDataPoint> valuesP;
GraphPie graphP;

ArrayList<BarDataPoint1> valuesB1;
GraphBar1 graphB1;

ArrayList<RouteDataPoint> valuesDS;
DensityGraph graphD;
//SimpleGraph graphS;

ArrayList<BarDataPoint2> valuesB2;
GraphBar graphB2;

ArrayList<DelaysDataPoint> valuesT;
GraphTimeAccuracy graphT;

ArrayList<RouteDataPoint> valuesA;
AirportGraph graphA;


int displayedGraph = 0;

//SETUP FUNCTION
void setup() {
  fullScreen();
  screen = new Screen(width, height);
  
  // THEME SETUP
  screen.changeTheme(THEMES.DEFAULT);
  ThemeSelection = new WidgetDropDown(width / 6, 0, (int)(width * 0.10416), (int)(height*0.037037), TextBoxFont, themeNames, "DEFAULT");
  ThemeSelection.selectedValue = "DEFAULT";
  
  //DATA SETUP

  QueriesInitial setupQuery = new QueriesInitial();
  setupQuery.createDatabase();
  setupQuery.useDatabase();
  setupQuery.dropAndCreateTable();
  setupQuery.insertRows();

  TextBoxFont = loadFont("default.vlw");
  headingFont = loadFont("Heading.vlw");

  // DATE TEXT BOX SETUP
  startDate = new WidgetTextBox((int) (width * 0.08), (int) (height * 0.1), screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "DD/MM/YYYY", WIDGET_TEXT_TYPE.DATE);
  endDate = new WidgetTextBox((int) (width * 0.17), (int) (height * 0.1), screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "DD/MM/YYYY", WIDGET_TEXT_TYPE.DATE);
  textBoxList.add(startDate);
  textBoxList.add(endDate);

  // TEXTBOX SETUP
  WidgetTextBox departureLowerSelection = new WidgetTextBox((int) (width * 0.08), (int) (height * 0.25), screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "??:??", WIDGET_TEXT_TYPE.TIME);
  WidgetTextBox departureUpperSelection = new WidgetTextBox((int) (width * 0.17), (int) (height * 0.25), screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "??:??", WIDGET_TEXT_TYPE.TIME);
  WidgetTextBox arrivalLowerSelection = new WidgetTextBox((int) (width * 0.08), (int) (height * 0.35), screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "??:??", WIDGET_TEXT_TYPE.TIME);
  WidgetTextBox arrivalUpperSelection = new WidgetTextBox((int) (width * 0.17), (int) (height * 0.35), screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "??:??", WIDGET_TEXT_TYPE.TIME);
  textBoxList.add(departureLowerSelection);
  textBoxList.add(departureUpperSelection);
  textBoxList.add(arrivalLowerSelection);
  textBoxList.add(arrivalUpperSelection);

  // AIRPORT DROP DOWN SETUP
  QueriesSelect selectQuery = new QueriesSelect();
  String[] departureAirports = selectQuery.getDepartureAirports();
  String[] arrivalAirports = selectQuery.getArrivalAirports();
  WidgetDropDown departures = new WidgetDropDown((int) (width * 0.13), (int) (height * 0.6), 200, 50, TextBoxFont, arrivalAirports, "");
  dropDownList.add(departures);
  WidgetDropDown arrivals = new WidgetDropDown((int) (width * 0.13), (int) (height * 0.52), 200, 50, TextBoxFont, departureAirports, "");
  dropDownList.add(arrivals);

  // RELOAD BUTTON SETUP
  ReloadButton = new WidgetButton((int) (width * 0.025), (int) (height * 0.88), 75, 75, 1);
  reloadButton = loadImage("reload.png");

  // TAB BUTTON SETUP
  int totalTabWidth = screen.TAB_WIDTH + screen.TAB_BORDER_WIDTH;
  int tabRange = width - totalTabWidth;

  for (int i = 0; i < 3; i++) // We lerp through the upper tab, adding the tab buttons at intervals to make sure they are equally spaced
  {
    int x = (int) (lerp(totalTabWidth, width, (float)(((float)i / (float)3))));    // We use lerop to find the range of the buttons and add them;
    TabButtons.add(new WidgetButton(x, 0, tabRange/3, (int)(height / 10), 0));
  }
  TabButtons.get(0).active = true; // Tab 1 is on by default at the start

  // SCROLL BUTTON SETUP
  moveLeft = new WidgetButton((int)(width * 0.572916), (int)(height * 0.925925), 50, 50, 5);
  moveRight = new WidgetButton((int)(width * 0.677083), (int)(height * 0.925925), 50, 50, 5);

  
  leftButton = loadImage("left.png");
  rightButton = loadImage("right.png");
  
  
  carrierAA = loadImage(sketchPath() +"/data/airline carriers/AA.png");
  carrierAS = loadImage(sketchPath() +"/data/airline carriers/AS.png");
  carrierB6 = loadImage(sketchPath() +"/data/airline carriers/B6.png");
  carrierG4 = loadImage(sketchPath() +"/data/airline carriers/G4.png");
  carrierHA = loadImage(sketchPath() +"/data/airline carriers/HA.png");
  carrierNK = loadImage(sketchPath() +"/data/airline carriers/NK.png");
  carrierWN = loadImage(sketchPath() +"/data/airline carriers/WN.png");
  carrierUA = loadImage(sketchPath() +"/data/airline carriers/UA.png");
  carrierDL = loadImage(sketchPath() +"/data/airline carriera/DL.png");
  
  /*cancelledFlights = new WidgetButton(width/20, height / 10 * 7, 50, 50, 20);
  delayedFlights = new WidgetButton(width/20 * 2, height / 10 * 7, 50, 50, 20);
  undisturbedFlights = new WidgetButton(width/20 * 3, height / 10 * 7, 50, 50, 20);
  
  cancelledButton = loadImage("cancelled.png");
  delayedButton = loadImage("diverted.png");
  undisturbedButton = loadImage("uninterrupted.png");*/
  
  // Tab 1 setup
  // please do not move this outside of setup void, for some reason processing does not like that

  // Tab 2 setup


  // GRAPH SETUP
  
  QueriesSelect queries = new QueriesSelect();
  
  
  valuesP = queries.getRowsPieChart(depTime, 0000, 2300, departures.selectedValue, arrivals.selectedValue, startDate.num1, endDate.num1);
  valuesB1 = queries.getRowsBarGraph1(true, 0000, 2300, departures.selectedValue, arrivals.selectedValue, startDate.num1, endDate.num1);
  valuesB2 = queries.getRowsBarGraph2();
  valuesDS = queries.getBusyRoutes();
  valuesA = queries.getAllRoutes();
  valuesT = queries.getRowsDelayGraph();

  graphP = new GraphPie(1300, 600, 700, 700);
  graphB1 = new GraphBar1(600, 250, 1200, 700);
  graphB2 = new GraphBar(600, 250, 1200, 700);
  graphD = new DensityGraph(850, 250, 650, 650);
  //graphS = new SimpleGraph(600, 500, 1200, 1000);
  graphT = new GraphTimeAccuracy(600, 500, 1400, 140);

  //Graph[] graphs = {graphB, graphP, graphD, graphS, graphA};
  Graph[] graphs = new Graph[6];
  screen.numberOfGraphs = graphs.length;

  // Tab 3 setup
  graphA = new AirportGraph(600, 250, 1200, 700);
}

void draw() {

  /*
  undisturbedFlights.render();
  cancelledFlights.render();
  delayedFlights.render();
   */

  background(screen.BACKGROUND);

  noStroke();

  moveLeft.render();
  moveRight.render();

  screen.renderDIP();
  
  ReloadButton.render();
  screen.renderButtons();
  
  /*
  image(cancelledButton, width/20, height / 10 * 7, 50, 50);
  image(delayedButton, width/20 * 2, height / 10 * 7, 50, 50);
  image(undisturbedButton, width/20 * 3, height / 10 * 7, 50, 50);*/
  
  image(leftButton, (int)(width * 0.572916), (int)(height * 0.925925), 50, 50);
  image(rightButton, (int)(width * 0.677083), (int)(height * 0.925925), 50, 50);
  
  image(reloadButton, (int) (width * 0.025), (int) (height * 0.88), 75, 75);
  
  switch (currentlyActiveTab) {
  case 0: // user is looking at tab 1
    screen.renderTab1();
    break;
  case 1: // user is looking at tab 2
    screen.renderTab2();
    break;
  case 2: // user is looking at tab 2
    screen.renderTab3();
    break;
  default:
    println("Tab not found");
    currentlyActiveTab = 0;
    break;
  }
  ThemeSelection.render();
}

// Goes through every button on the screen and commands them to check if they have been clicked
// This method always updated the tab and theme at the end aswell in case the user clicked anything relating to their selection - Angelos
void mouseClicked() {
  if (ReloadButton.isClicked()) 
  {
    ReloadButton.active = true;
    ReloadButton.render();
    ReloadEvent();
    //screen.renderTab1();
    ReloadButton.active = false;
    ReloadButton.render();
    
    QueriesSelect queries = new QueriesSelect();
    valuesP = queries.getRowsPieChart(true, 0000, 2300, dropDownList.get(0).selectedValue, dropDownList.get(1).selectedValue, startDate.num1, endDate.num1);
    valuesB1 = queries.getRowsBarGraph1(true, 0000, 2300, dropDownList.get(0).selectedValue, dropDownList.get(1).selectedValue, startDate.num1, endDate.num1);
  }
  for (int i = 0; i < TabButtons.size(); i++) 
  { // we first investigate if the user is trying to change tabs
    if (TabButtons.get(i).isMouseover()) {  // For every tab button
      TabButtons.get(i).active = true;  // We find the active button
      for (int j = 0; j < TabButtons.size(); j++) 
      {
        if (TabButtons.get(i) != TabButtons.get(j)) 
        { // We disable all other buttons
          TabButtons.get(j).active = false;
        }
      } // This means that that only tab button is on at any given moment, and if the user clicks the same one twice it makes no difference
      break;
    }
  }
  updateTabs();
  screen.pageSelectButtons();
  ThemeSelection.isClicked();
  if (isDropDownActive) 
  {
    for (int i = 0; i < dropDownList.size(); i++) 
    {
      dropDownList.get(i).isClicked();
    }
  } else 
  {
    for (int i = 0; i < textBoxList.size(); i++) 
    {
      textBoxList.get(i).isClicked();
    }
    for (int i = 0; i < dropDownList.size(); i++) 
    {
      dropDownList.get(i).isClicked();
    }
  }

  screen.changeTheme(stringToEnum(ThemeSelection.selectedValue));
}

// setup place holder values
boolean depTime = false;
int time1 = 0;
int time2 = 0;
  
// creates all query related data pieces and collect the data from input buttons, some of the data is also processed
// to be compatible with our query system requirements, the filteredData attaylist is then adjusted to contain the new data - Angelos
void ReloadEvent() {

  String selectedArrivalStation = "";
  String selectedDepartureStation = "";
  String date1 = null;
  String date2 = null;

  // TIME SELECTION

  // call the time inputs from the departure and arrival time selection buttons
  if ((textBoxList.get(2).textValue != textBoxList.get(2).normal) && (textBoxList.get(3).textValue != textBoxList.get(3).normal))
  { // if departure airport time selection has a valid input
    time1 = Integer.parseInt(textBoxList.get(2).giveProcessedUserInput());
    time2 = Integer.parseInt(textBoxList.get(3).giveProcessedUserInput());
    textBoxList.get(4).textValue = textBoxList.get(4).normal; // we flush the other time selection buttons in case the user has inputted anything there
    textBoxList.get(5).textValue = textBoxList.get(5).normal;
    depTime = false;
  } else if ((textBoxList.get(4).textValue != textBoxList.get(4).normal) && (textBoxList.get(5).textValue != textBoxList.get(5).normal))
  { // if arrival airport time selection has a valid input
    time1 = Integer.parseInt(textBoxList.get(4).giveProcessedUserInput());
    time2 = Integer.parseInt(textBoxList.get(5).giveProcessedUserInput());
    textBoxList.get(2).textValue = textBoxList.get(2).normal; // we flush the other time selection buttons in case the user has inputted anything there
    textBoxList.get(3).textValue = textBoxList.get(3).normal;
    depTime = true;
  } else
  {
    // we flush all time selection buttons in case the user has inputted anything there that is incomplete and as such invalid
    time1 = 0000;
    time2 = 0000;
    textBoxList.get(2).textValue = textBoxList.get(2).normal;
    textBoxList.get(3).textValue = textBoxList.get(3).normal;
    textBoxList.get(4).textValue = textBoxList.get(4).normal;
    textBoxList.get(5).textValue = textBoxList.get(5).normal;
    depTime = false;
  }


  // DATE SELECTION
  if ((textBoxList.get(0).textValue != "" || textBoxList.get(0).textValue != null) && (textBoxList.get(1).textValue != "" || textBoxList.get(1).textValue != null))
  {
    date1 = textBoxList.get(0).giveProcessedUserInput();
    date2 = textBoxList.get(1).giveProcessedUserInput();
  } else
  {
    // if the user did not give a full date seelction we empty date selection, the dates are left null
    textBoxList.get(0).userInputInvalid();
    textBoxList.get(1).userInputInvalid();
  }


  // AIRPORT SELECTION
  // If the drop down has a selected item on it, selectedArrivalStation stores it
  if (dropDownList.get(0).selectedValue != "") {
    selectedArrivalStation = dropDownList.get(0).selectedValue;
  } else { // or else it becomes null
    selectedArrivalStation = null;
  }
  // Repeat for departure station
  if (dropDownList.get(1).selectedValue != "") {
    selectedDepartureStation = dropDownList.get(1).selectedValue;
  } else {
    selectedDepartureStation = null;
  }
  
  long startTime = System.nanoTime();

  QueriesSelect selectQuery = new QueriesSelect();
  filteredData = selectQuery.getRowsDisplay(depTime, time1, time2, selectedArrivalStation, selectedDepartureStation, date1, date2);

  long endTime = System.nanoTime();
  long elapsedTime = endTime - startTime;
  double elapsedTimeInMs = (double) elapsedTime / 1_000_000.0;
  println("Elapsed Time: " + elapsedTimeInMs + " milliseconds, that is how long it took to add the new data to the filteredData array");
  
  // EMMA OVER HERE 
  valuesB1 = selectQuery.getRowsBarGraph1(depTime, time1, time2, selectedArrivalStation, selectedDepartureStation, date1, date2);
  for (int i = 0; i < valuesB1.size(); i++){
    BarDataPoint1 data = valuesB1.get(i);
    println(data.FLIGHT_COUNT);
  }
  // screen setup
  screen.numberOfPages = (int)(filteredData.size() / 10); // number of pages = the number of pages that we need to display the data
  screen.numberOfPages++; // add 1 to take into account 0, i.e what if we have 7 elements to display, we still need 1 page
  screen.selectedPage = 1;
}

// check user scroll input, and apply the scroll to all active drop down buttons, inactive drop down buttons simply ignore this call - Angelos
void mouseWheel(MouseEvent event) {
  for (int i = 0; i < dropDownList.size(); i++) {
    dropDownList.get(i).scroll((int)event.getCount());
  }
  ThemeSelection.scroll((int)event.getCount());
}

// checks if the any buttons that can accept text input are active, if yes, it sends them the input to be processed - Angelos
void keyPressed() {
  for (int i = 0, n = textBoxList.size(); i < n; i++) {
    if (textBoxList.get(i).active) {
      textBoxList.get(i).input(key);
    }
  }
  if(ThemeSelection.amIActive)
  {
    ThemeSelection.searchBarinput(key);
  }
  for (int i = 0; i < dropDownList.size(); i++) 
  {
    if(dropDownList.get(i).amIActive)
    {
      dropDownList.get(i).searchBarinput(key);
    }
  }
}

// Updates the user tabs at the top of the screen to reflect which tab is currently active and deactivate all other tabs - Angelos
void updateTabs() {
  for (int i = 0; i < TabButtons.size(); i++) {
    if (TabButtons.get(i).active) {
      currentlyActiveTab = i;
    }
  }
}

// takes the input of the themes button and returns the selected enum
// In java there are better ways to do this, but with processing this is as good as it gets - Angelos
THEMES stringToEnum(String input) {
    switch(input) {
        case "DEFAULT":
            return THEMES.DEFAULT;
        case "GIRLBOSS":
            return THEMES.GIRLBOSS;
        case "BOYBOSS":
            return THEMES.BOYBOSS;
        case "DAY":
            return THEMES.DAY;
        case "DUSK":
            return THEMES.DUSK;
        case "COSMIC":
            return THEMES.COSMIC;
        case "RUST":
            return THEMES.RUST;
        case "MARINE":
            return THEMES.MARINE;
        case "STELLAR":
            return THEMES.STELLAR;
        case "COLOURBLIND":
            return THEMES.COLOURBLIND;
        default:
            return THEMES.DEFAULT;
    }
}

// This function simply ensures that only one of the 3 radio buttons at the bottom of the buttons display is active
// And that if the user clicks on an active one they are all disabled - Angelos

/*
void radioButtonsFlightStatus() {
 if (cancelledFlights.isClicked()) {
 if (!cancelledFlights.active) {
 cancelledFlights.active = true;
 delayedFlights.active = false;
 undisturbedFlights.active = false;
 } else {
 cancelledFlights.active = false;
 delayedFlights.active = false;
 undisturbedFlights.active = false;
 }
 }
 if (delayedFlights.isClicked()) {
 if (!delayedFlights.active) {
 cancelledFlights.active = false;
 delayedFlights.active = true;
 undisturbedFlights.active = false;
 } else {
 cancelledFlights.active = false;
 delayedFlights.active = false;
 undisturbedFlights.active = false;
 }
 }
 if (undisturbedFlights.isClicked()) {
 if (!undisturbedFlights.active) {
 cancelledFlights.active = false;
 delayedFlights.active = false;
 undisturbedFlights.active = true;
 } else {
 cancelledFlights.active = false;
 delayedFlights.active = false;
 undisturbedFlights.active = false;
 }
 }
}
*/



void mousePressed()
{ 
  if (graphA.hoveredNode != null) 
  {
    graphA.selectAirport();
    graphA.isDragging = true;
    graphA.offsetX = mouseX - graphA.hoveredNode.x;
    graphA.offsetY = mouseY - graphA.hoveredNode.y;
  } 
  else
  graphA.deselectAirport();
}

void mouseReleased()
{
  // Stop dragging when the mouse is released
  graphA.isDragging = false;
}

void mouseMoved()
{
  graphA.hoveredNode = graphA.getNodeUnderMouse();
}

void mouseDragged() {
  if (graphA.isDragging && graphA.hoveredNode != null)
  {
    // Calculate the difference between the current and previous mouse positions
    float deltaX = mouseX - pmouseX;
    float deltaY = mouseY - pmouseY;
     // Update position of the main dragged node
    graphA.hoveredNode.x += deltaX;
    graphA.hoveredNode.y += deltaY;

    // Update positions of connected nodes (neighbors)
    for (AirportNode neighbor : graphA.hoveredNode.neighbors.keySet())
    {
      // Calculate dampening factors based on the size of the nodes
      float nodeSizeRatio = graphA.hoveredNode.radius / neighbor.radius; // Calculate size ratio
      float dampeningFactor = 0.2 * nodeSizeRatio; // Adjust the dampening factor based on size ratio
      
      // Apply dampening effect to the movement of connected nodes
      float neighborDeltaX = deltaX * dampeningFactor; // Apply dampening to the horizontal movement
      float neighborDeltaY = deltaY * dampeningFactor; // Apply dampening to the vertical movement
      
      // Update position of the connected node
      neighbor.x += neighborDeltaX;
      neighbor.y += neighborDeltaY;
      
      // Update positions of nodes connected to the connected node
      for (AirportNode nestedNeighbor : neighbor.neighbors.keySet()) {
        // Calculate nested dampening factors based on the size of the nodes
        float nestedNodeSizeRatio = neighbor.radius / nestedNeighbor.radius; // Calculate size ratio
        float nestedDampeningFactor = 0.1 * nestedNodeSizeRatio; // Adjust the nested dampening factor based on size ratio
        
        // Apply further dampening effect to the movement of nested connected nodes
        float nestedNeighborDeltaX = neighborDeltaX * nestedDampeningFactor; // Apply dampening to the horizontal movement
        float nestedNeighborDeltaY = neighborDeltaY * nestedDampeningFactor; // Apply dampening to the vertical movement
       
        // Update position of the nested connected node
        nestedNeighbor.x += nestedNeighborDeltaX;
        nestedNeighbor.y += nestedNeighborDeltaY;
      }
    }
      // Update the original mouse position
    graphA.offsetX = mouseX - graphA.hoveredNode.x;
    graphA.offsetY = mouseY - graphA.hoveredNode.y;
  }
}

// In modern java an enum can be associated to a number, not in processing, this function converts the index of the theme that the user has selected
// in the theme selection button to the curresponding theme in the enum, this is a product of using processing unfortunetly
THEMES indexToTheme(int index)
{
  switch(index)
  {
    case 1:
      return THEMES.GIRLBOSS;
    case 2:
      return THEMES.BOYBOSS;
    case 3:
      return THEMES.DAY;
    case 4:
      return THEMES.DUSK;
    default:
      return THEMES.DEFAULT;
  }
}
