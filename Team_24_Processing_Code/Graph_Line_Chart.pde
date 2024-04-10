// This SimpleGraph class, extending Graph, draws a simple graph based on provided route data points:
// It initializes drawing variables and calculates point spacing.
// It finds the maximum flight count among the data points.
// It draws the graph by iterating through the data points, mapping heights relative to canvas height and plotting points.
// It labels each point with the corresponding origin and destination airports.
// It draws a scale on the y-axis to represent flight count using the maximum flight count and top margin.
import java.util.ArrayList;
// Define a class SimpleGraph extending the Graph class
class SimpleGraph extends Graph {
SimpleGraph(int x, int y, int wide, int high){
     super(x, y, wide, high);
  }
 // Method to draw the simple graph

    void draw(ArrayList<RouteDataPoint> values) {
        // Set up variables for drawing
        float topMargin = 50;
        float leftMargin = 50;
        float pointSpacing = (width - leftMargin) / values.size();
        
        // Find the maximum flight count to scale the graph
        int maxFlightCount = 0;
        for (RouteDataPoint data : values) {
            maxFlightCount = Math.max(maxFlightCount, data.FLIGHT_COUNT);
        }
        
        // Draw the density graph
        beginShape();
        noFill();
        stroke(50, 100, 200);// Set stroke color (example color, change as needed)
        strokeWeight(2); // Set stroke weight
        for (int i = 0; i < values.size(); i++) {
            RouteDataPoint data = values.get(i);
            
            // Calculate the height of each point relative to the canvas height
            float pointHeight = map(data.FLIGHT_COUNT, 0, maxFlightCount, height + ypos, ypos);
            
            // Calculate the x-coordinate of each point
            float x = xpos + leftMargin + i * pointSpacing;
            
            // Draw the point
            vertex(x, pointHeight);
            
            // Draw the label at the bottom
            textAlign(CENTER, TOP);
            textSize(16);
            text(data.ORIGIN + "-" + data.DEST, x, ypos + height*1.1);
        }
        endShape();
        
        // Draw the scale
        drawScale(maxFlightCount, topMargin);
    }

   // Method to draw scale
    void drawScale(int maxValue, float topMargin) {
        float step = maxValue / 5; // Determine the step size for the scale

        // Draw tick marks and labels
        for (int i = 0; i <= 5; i++) {
            float yPos = map((i*step), 0, maxValue, height + ypos, ypos);

            // Draw tick mark
            stroke(100);
            line(xpos, yPos, xpos + width, yPos);

            // Draw label
            textAlign(LEFT, CENTER);
            text(nf(i * step, 0, 1), xpos, yPos + 10);
        }
    }
}
