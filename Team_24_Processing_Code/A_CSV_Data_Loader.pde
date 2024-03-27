//IMPORT FILES
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.regex.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


//STATIC SETUP VARIABLE
static ArrayList<WidgetTextBox> textBoxList = new ArrayList<WidgetTextBox>();
static ArrayList<WidgetButton> buttonList = new ArrayList<WidgetButton>();
static ArrayList<WidgetDropDown> dropDownList = new ArrayList<WidgetDropDown>();
static ArrayList<WidgetButton> TabButtons = new ArrayList<WidgetButton>(); // Tab buttons are in a seperate list to control their render order

static WidgetButton ReloadButton;
static WidgetButton moveLeft;
static WidgetButton moveRight;

static WidgetTextBox startDate;
static WidgetTextBox endDate;

color ON = color(100,255,100);
color OFF = color(255,100,100);
PFont TextBoxFont;

ArrayList<DisplayDataPoint> filteredData;

Screen screen = new Screen();
int currentlyActiveTab = 0;
boolean isDropDownActive = false;
int WIDGET_ROUNDNESS = 10;

  //BAR CHART SETUP

enum WIDGET_TEXT_TYPE{
  TIME,
  DATE
}

ArrayList<BarDataPoint> valuesB;
GraphBar graphB;

ArrayList<PieDataPoint> valuesP;
GraphPie graphP;
//SETUP FUNCTION
void setup() {
  fullScreen();
  
  
  //DATA SETUP
  QueriesInitial setupQuery = new QueriesInitial();
  setupQuery.createDatabase();
  setupQuery.useDatabase();
  setupQuery.dropAndCreateTable();
  setupQuery.insertRows();
  
  //TEXTBOX SETUP
  TextBoxFont = loadFont("default.vlw");
  WidgetTextBox departureTimeSelections = new WidgetTextBox(screen.HORIZONTAL_DISTANCE_FROM_WALL, screen.VERTICAL_DISTANCE_FROM_WALL+10, screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "??:?? - ??:??", WIDGET_TEXT_TYPE.TIME);
  WidgetTextBox arrivalTimeSelections = new WidgetTextBox(screen.HORIZONTAL_DISTANCE_FROM_WALL, screen.VERTICAL_DISTANCE_FROM_WALL + 500, screen.WIDTH_B, screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "??:?? - ??:??", WIDGET_TEXT_TYPE.TIME);
  textBoxList.add(departureTimeSelections);
  textBoxList.add(arrivalTimeSelections);
  
  
  //DATE TEXT BOX SETUP
  startDate = new WidgetTextBox(screen.HORIZONTAL_DISTANCE_FROM_WALL / 2, screen.VERTICAL_DISTANCE_FROM_WALL - 70, (int)(screen.WIDTH_B / 1.5), screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "dd/mm/yyyy", WIDGET_TEXT_TYPE.DATE);
  endDate = new WidgetTextBox(screen.HORIZONTAL_DISTANCE_FROM_WALL *2, screen.VERTICAL_DISTANCE_FROM_WALL - 70, (int)(screen.WIDTH_B / 1.5), screen.HEIGHT_B, WIDGET_ROUNDNESS, TextBoxFont, "dd/m/yyyy", WIDGET_TEXT_TYPE.DATE);
  textBoxList.add(startDate);
  textBoxList.add(endDate);
  
  
  //AIRPORT DROP DOWN SETUP
  QueriesSelect selectQuery = new QueriesSelect();
  String[] departureAirports = selectQuery.getDepartureAirports();
  String[] arrivalAirports = selectQuery.getArrivalAirports();  
  WidgetDropDown arrivals = new WidgetDropDown(300, 210, 200, 50, TextBoxFont, departureAirports);
  dropDownList.add(arrivals);
  WidgetDropDown departures = new WidgetDropDown(300, 700, 200, 50, TextBoxFont, arrivalAirports);
  dropDownList.add(departures);
  
  
  //TAB BUTTON SETUP
  int totalTabWidth = screen.TAB_WIDTH + screen.TAB_BORDER_WIDTH;
  int tabRange = width - totalTabWidth;
  
  //GRAPH SETUP
  QueriesSelect queries = new QueriesSelect();
  valuesB = queries.getRowsBarGraph();
  graphB = new GraphBar(600, 250, 1200, 700);
  valuesP = queries.getRowsPieChart();
  graphP = new GraphPie(1300, 560, 800, 800);
  
  int displayedGraph = 0;
  Graph[] graphs = new Graph[2];
  graphs[0] = graphB;
  graphs[1] = graphP;

  for(int i = 0; i < 3; i++) // We lerp through the upper tab, adding the tab buttons at intervals to make sure they are equally spaced
  {
    int x = (int)(lerp(totalTabWidth, width, (float)(((float)i / (float)3))));    // We use lerop to find the range of the buttons and add them;
    TabButtons.add(new WidgetButton(x,0,tabRange/3, (int)(height / 10), 0, ON, OFF));
  }
  TabButtons.get(0).active = true; // Tab 1 is on by default at the start
 
  // Tab 1 setup
  // please do not move this outside of setup void, for some reason processing does not likey likey that
  
  // Tab 2 setup
  //GraphPie pie1 = new GraphPie();
  ReloadButton = new WidgetButton(50, 50, 50, 50, 1, ON, OFF);
  
  
  //SCROLL BUTTON SETUP
  moveLeft = new WidgetButton(1100, 1000, 50, 50, 5, ON, OFF);
  moveRight = new WidgetButton(1300, 1000, 50, 50, 5, ON, OFF);
}


void draw(){
  
  background(255,255,255);
  moveLeft.render();
  moveRight.render();
  // REMINDER: from now on buttons and the tab on the left on the screen are always the same regardless of selected tab
  // User tab selection only effects everything on the right
  screen.renderDIP();
  screen.renderButtons();
  switch(currentlyActiveTab)
  {
    case 0: // user is looking at tab 1
      screen.renderTab1();
      break;
    case 1: // user is lookingat tab 2
      screen.renderTab2();
      break;
    default:
      println("Tab not found");
      currentlyActiveTab = 0;
      break;
  }
  ReloadButton.render();
}


//ADD COMMENT
void mouseClicked(){
  if(ReloadButton.isClicked())
  {
    ReloadButton.active = true;
    ReloadButton.render();
    RealoadEvent();
    ReloadButton.active = false;
    ReloadButton.render();
  }
  for(int i = 0; i < TabButtons.size(); i++) // we first investigate if the user is trying to change tabs
  {
     if(TabButtons.get(i).isMouseover())  // For every tab button
     {
       TabButtons.get(i).active = true;  // We find the active button
       for(int j = 0; j < TabButtons.size(); j++)
       {
         if(TabButtons.get(i) != TabButtons.get(j)) // We disable all other buttons
         {
           TabButtons.get(j).active = false;
         }
       } // This means that that only tab button is on at any given moment, and if the user clicks the same one twice it makes no difference
       break;
     }
  }
  updateTabs();
  hasUserChangedPage();
  if(isDropDownActive)
  {
    for(int i = 0; i < dropDownList.size(); i++)
    {
      dropDownList.get(i).isClicked();
    }
  } else 
  {
    for(int i  = 0; i < textBoxList.size(); i++)
    {
      textBoxList.get(i).isClicked();
    }
    for(int i = 0; i < buttonList.size(); i++)
    {
      
    }
    for(int i = 0; i < dropDownList.size(); i++)
    {
      dropDownList.get(i).isClicked();
    }
  }
}
/*void keyPressed(){ // todo, lots of this code is redudant since the user always has access to the buttons
    switch(currentlyActiveTab) 
    {
      case 0:   // User is on tab 1

        for(int i  = 0; i < textBoxList.size(); i++)
        {
          if(textBoxList.get(i).active)
          {
          textBoxList.get(i).input(key);
          delay(10); // We must delay to stop the user from accidentally holding a key causing many inputs at once
          }
        }
    }
}*/


//ADD COMMENT
void RealoadEvent(){
  // setup place holder values
  boolean depTime;
  int num1;
  int num2;
  
  String selectedAriivalStation = "";
  String selectedDepartureStation = "";
  
  // insert user querry values to the right places
  if(textBoxList.get(1).textValue != "??:?? - ??:??"){
    depTime = false;
    num1 = Integer.parseInt(textBoxList.get(1).num1.trim());
    num2 = Integer.parseInt(textBoxList.get(1).num2.trim());
  } else  if ((textBoxList.get(0).textValue != "??:?? - ??:??"))
  {
    depTime = true;
    num1 = Integer.parseInt(textBoxList.get(0).num1.trim());
    num2 = Integer.parseInt(textBoxList.get(0).num2.trim());
  } else 
  {
    depTime = true; // doesn't matter
    num1 = 0000;
    num2 = 0000;
  }

  
  if(dropDownList.get(0).currentlySelectedElement != -1)
  {
    selectedAriivalStation = dropDownList.get(0).elements[dropDownList.get(0).currentlySelectedElement];
  } 
  else {
    selectedAriivalStation = null;
  }
  
  
  if(dropDownList.get(1).currentlySelectedElement != -1)
  {
    selectedDepartureStation = dropDownList.get(1).elements[dropDownList.get(1).currentlySelectedElement];
  } 
  else {
    selectedDepartureStation = null;
  }
  
  QueriesSelect selectQuery = new QueriesSelect();
  filteredData = selectQuery.getRowsDisplay(depTime, num1, num2, selectedAriivalStation, selectedDepartureStation);
  // screen setup
  screen.numberOfPages = (int)(filteredData.size() / 10); // number of pages = the number of pages that we need to display the data
  screen.numberOfPages++; // add 1 to take into account 0, i.e what if we have 7 elements to display, we still need 1 page
  screen.selectedPage = 1;
  
}


//ADD COMMENT
void mouseWheel(MouseEvent event){
  for(int i = 0; i < dropDownList.size(); i++)
  {
    dropDownList.get(i).scroll((int)event.getCount());
  }
}


//ADD COMMENT
void updateTabs(){
  for(int i = 0; i < TabButtons.size(); i++)
  {
    if(TabButtons.get(i).active)
    {
      currentlyActiveTab = i;
    }
  }
}


// ADD COMMENT
void hasUserChangedPage(){
  
  if(moveLeft.isClicked())
  {
    switch(currentlySelectedTab)
    {
      case 0:
        screen.selectedPage--;
        if(screen.selectedPage <= 0)
          screen.selectedPage = 1;
        break;
      case 1:
        screen.displayedGraph--;
        if(screen.displayedGraph <= 0)
          screen.displayedGraph = 1;
        break;
      default:
        println("No function");
        break;
    }
  }
  
  if(moveRight.isClicked()){
    switch(currentlySelectedTab)
    {
      case 0:
        screen.selectedPage++;
        if(screen.selectedPage > screen.numberOfPages)
          screen.selectedPage = screen.numberOfPages;
        break;
      case 1:
        screen.displayedGraph++;
        if(screen.displayedGraph <= 1)
          screen.displayedGraph = 0;
        break;
      default:
        println("No function");
        break;
    }
}
