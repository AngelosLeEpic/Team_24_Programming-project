class GraphBar extends Graph {

  GraphBar(int x, int y, int wide, int high) {
    super(x, y, wide, high);
  }


  void drawBarChart(ArrayList<BarDataPoint2> values) {
    // Set up variables for bar width, spacing, margins, and color
    // Set up variables for bar width and spacing
    float barSpacing = 20;
    float topMargin = 50;
    float leftMargin = 50;
    int barColour = 50;
    float barWidth = (width - leftMargin) / values.size() - barSpacing;

    String suffix = "";
    float maxVal = 0;
    // Find the maximum value in the dataset
    for (BarDataPoint2 data : values) {
      maxVal = max(maxVal, data.getTOTAL_DIST());
    }
    
  if (maxVal % 10 != 0)
    {
      float max = maxVal;
      byte lengthOfMax = 0;
      
      while (max > 10)
      {
        max /= 10;
        lengthOfMax++;
      }
      
      max = round(max);      
      for(int i = 0; i < lengthOfMax; i++)
        max *= 10;
      
      maxVal = round(max);
    }

    // Loop through the ArrayList of BarDataPoint objects to draw each bar
    for (int i = 0; i < values.size(); i++) {
      BarDataPoint2 data = values.get(i);
      // Calculate the height of each bar relative to the canvas height
      float barHeight = map(data.getTOTAL_DIST(), 0, maxVal, 0, height - topMargin);

      // Calculate the position of each bar
      float x = xpos + leftMargin + i * (barWidth + barSpacing);
      float y = ypos + height - barHeight;

      // Draw the bar
      fill(screen.SECONDARY_COLOR);
      rect(x, y, barWidth, barHeight);

      // Draw the label
      textAlign(CENTER, CENTER - 20);
      fill(screen.TEXT_COLOR);
      text(data.getMKT_CARRIER(), x + barWidth/2, y - 10);

    }
    
    // Draw the scale based on the maximum value and top margin
    drawScale(maxVal, topMargin, suffix);
  }

  // Method to draw the scale for the bar chart

  void drawScale(float maxValue, float topMargin, String suffix)
  {
    float step = maxValue / 5; // Determine the step size for the scale
    
    byte suffixByte = 0;
    while (maxValue >= 10000)
    {
      maxValue /= 1000;
      suffixByte++;
    }
    switch(suffixByte)
    {
      case 1:
        suffix = "K";
        break;
      case 2:
        suffix = "M";
        break;
      default:
        break;
    }

    // Draw tick marks and labels
    for (int i = 0; i <= 5; i++) {
      float yPos = map(ypos + (i * step), 0, step*5, height, 0);

      // Draw tick mark
      line(xpos + 10, yPos, xpos, yPos);

      // Draw label
      textAlign(LEFT, CENTER);
      text(nf(i * maxValue, 0, 1) + suffix, xpos - 20, yPos + ypos);
    }
  }
}
