/*
class GraphPie extends Graph {
 GraphPie(int x,int y,int w,int h){
 super(x,y,w,h);
 }
 void drawPieChart(ArrayList<PieDataPoint> values){
 String[] labels = {"Flights Cancelled", "Flights Diverted", "Flights As Expected"};
 int totalFlights = values.size();
 float startAngle = 0;
 float labelX = 10;
 float labelY = 5;
 float colour = 0.0;
 for (int i = 0; i < labels.length; i++) {
 float angle = radians(map(i, 0, labels.length, 0, 360)); ; // Calculate angle for this slice
 float endAngle = startAngle + angle;
 
 // Calculate slice color
 // ugly colours
 //colorMode(HSB);
 //fill(map(i, 0, labels.length, 0, 255), 255, 255);
 // greyscale
 fill(map(i, 0, totalFlights, colour, colour), colour, colour);
 colour += 255.0/totalFlights*2;
 
 // Draw slice
 arc(width/2, height/2, 300, 300, startAngle, endAngle);
 
 // Draw label
 labelY += 15;
 //textAlign(CENTER, CENTER);
 text(labels[i], labelX, labelY);
 
 startAngle += angle;
 }
 }
 }
 */
 
 
//Experemental alternative version of graph pie by angelos

class GraphPie extends Graph {
  int cancelledFlights;
  int divertedFlights;
  int indistrbedFlights;
  int totalFlights;
  String[] labels = {"Flights Cancelled", "Flights Diverted", "Flights As Expected"};
  GraphPie(int x, int y, int w, int h) {
    super(x, y, w, h);
  }

  void calculateFlights(ArrayList<DisplayDataPoint> newData)
  {
    if (newData == null || newData.size() == 0)
    {
      cancelledFlights = 0;
      divertedFlights = 0;
      indistrbedFlights = 0;
      totalFlights = 0; // avoid divide by 0
    } else
    {
      cancelledFlights = 0;
      divertedFlights = 0;
      indistrbedFlights = 0;
      totalFlights = newData.size();

      for (DisplayDataPoint data : newData)
      {
        if (data.CANCELLED == 1) {
          cancelledFlights++;
        } else if (data.DIVERTED == 1) {
          divertedFlights++;
        } else {
          indistrbedFlights++;
        }
      }
    }
  }

  void render()
  {
    if (totalFlights != 0) {
      float[] angles = new float[3];
      angles[0] = PApplet.map(cancelledFlights, 0, totalFlights, 0, PApplet.TWO_PI);
      angles[1] = PApplet.map(divertedFlights, 0, totalFlights, 0, PApplet.TWO_PI);
      angles[2] = PApplet.map(indistrbedFlights, 0, totalFlights, 0, PApplet.TWO_PI);

      float lastAngle = 0;
      for (int i = 0; i < angles.length; i++) {
        if(i == 0){fill(screen.PRIMARY_COLOR);}
        if(i == 1){fill(screen.SECONDARY_COLOR);}
        if(i == 2){fill(screen.TERTIARY_COLOR);}
        arc(xpos + width/2, ypos + height/2, width, height, lastAngle, lastAngle + angles[i]);
        lastAngle += angles[i];
      }

      // Display legend
      for (int i = 0; i < labels.length; i++) {
        if(i == 0){fill(screen.PRIMARY_COLOR);}
        if(i == 1){fill(screen.SECONDARY_COLOR);}
        if(i == 2){fill(screen.TERTIARY_COLOR);}
        rect(xpos + width + 10, ypos + i * 20, 10, 10);
        text(labels[i], xpos + width + 25, ypos + i * 20 + 10);
      }
    }
  }
}
