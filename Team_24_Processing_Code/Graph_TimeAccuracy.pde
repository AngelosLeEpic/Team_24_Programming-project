class GraphTimeAccuracy extends Graph {
  GraphTimeAccuracy(int x, int y, int w, int h)
  {
    super(x, y, w, h);
  }
  
  void draw(ArrayList<DelaysDataPoint> data)
  {
    //color boxColour = (50), lineColour = (200);
    int boxLength = width, boxWidth = height;
    int maxDeviation = 0;
   
    for (DelaysDataPoint values : data)
    {
      maxDeviation = max(maxDeviation, Math.abs(values.AVG_DELAY));
    }
    
    int lineThickness = 2;
    int incrementCount = 20;
    int incrementUnits = ((maxDeviation+incrementCount)/incrementCount) * 2;
    int incrementSpace = (int) boxLength/incrementCount;

    // drawing main box
    fill(screen.SECONDARY_COLOR);
    rect(xpos, ypos, boxLength, boxWidth);
    fill(screen.TERTIARY_COLOR);
    rect(xpos+(boxLength/2), ypos, 5, boxWidth);
    
    // drawing time increment labels
    fill(screen.TEXT_COLOR);
    textAlign(CENTER, BOTTOM);
    for (int i=0; i*incrementSpace <= boxLength/2; i++)
    {
      rect(xpos+(boxLength/2)+(i*incrementSpace), ypos-10, lineThickness, 10);
      text("+" + i*incrementUnits, xpos+(boxLength/2)+(i*incrementSpace), ypos-10);
      rect(xpos+(boxLength/2)-(i*incrementSpace), ypos-10, lineThickness, 10);
      text("-" + i*incrementUnits, xpos+(boxLength/2)-(i*incrementSpace), ypos-10);
    }
    // drawing carrier points and their labels
    
    textAlign(CENTER, TOP);
    fill(screen.TEXT_COLOR);
    
    for(int i=0; i<data.size(); i++)
    {
      DelaysDataPoint values = data.get(i);
      rect(xpos+(boxLength/2)+((incrementSpace*values.AVG_DELAY)/incrementUnits), ypos, lineThickness, boxWidth + i*15);
      text(values.MKT_CARRIER, xpos+(boxLength/2)+((incrementSpace*values.AVG_DELAY)/incrementUnits), ypos+boxWidth + i*15);
    }
  }
}
