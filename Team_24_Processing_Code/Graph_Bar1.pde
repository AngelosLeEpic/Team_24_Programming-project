class GraphBar1 extends Graph {

    GraphBar1(int x, int y, int wide, int high) {
        super(x, y, wide, high);
    }

void drawBarChart(ArrayList<BarDataPoint1> values) {
    // Set up variables for bar width, spacing, margins, and color
    float barSpacing = 20;
    float topMargin = 50;
    float leftMargin = 50;
    float barWidth = ((width - leftMargin) / values.size()) - barSpacing;

    // Get the maximum flight count
    int maxFlightCount = 0;
    for (BarDataPoint1 data : values) {
      maxFlightCount = Math.max(maxFlightCount, data.FLIGHT_COUNT);
    }
    
    if (maxFlightCount % 10 != 0)
    {
      float max = maxFlightCount;
      byte lengthOfMax = 0;
      
      while (max > 10)
      {
        max /= 10;
        lengthOfMax++;
      }
      max += 1;
      max = round(max);      
      for(int i = 0; i < lengthOfMax; i++)
        max *= 10;
      
      maxFlightCount = round(max);
    }

    // Loop through the ArrayList of BarDataPoint1 objects to draw each bar
    for (int i = 0; i < values.size(); i++) {
        BarDataPoint1 data = values.get(i);
        // Calculate the height of each bar relative to the canvas height
        float barHeight = map(data.FLIGHT_COUNT, 0, maxFlightCount, 0, height - topMargin);

        // Calculate the position of each bar
        float x = xpos + leftMargin + i * (barWidth + barSpacing);
        float y = ypos + height - barHeight - topMargin; // Adjusted to start from the bottom of the canvas

        // Draw the bar
        fill(screen.SECONDARY_COLOR);
        rect(x, y, barWidth, barHeight);

        // Draw the label
        textAlign(CENTER, CENTER - 20);
        fill(screen.TEXT_COLOR);
        text(data.MKT_CARRIER, x + barWidth/2, y - 10);
    }

    // Draw the scale based on the maximum flight count and top margin
    drawScale(maxFlightCount, topMargin);
}

void drawScale(float maxFlightCount, float topMargin) {
    float step = maxFlightCount / 5; // Determine the step size for the scale

    // Draw tick marks and labels
    for (int i = 0; i <= 5; i++) {
        float yPos = map(i * step, 0, maxFlightCount, ypos + height - topMargin, ypos);

        // Draw tick mark
        line(xpos + 10, yPos, xpos, yPos);

        // Draw label
        textAlign(LEFT, CENTER);
        text(nf(i * step, 0, 0), xpos - 20, yPos);

        // Draw horizontal line to align with the x-axis
        line(xpos, ypos + height - topMargin, xpos + width, ypos + height - topMargin);
    }
}


}
