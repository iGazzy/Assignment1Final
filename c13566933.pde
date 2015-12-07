//Import controlp5
import controlP5.*;

ControlP5 cp5;

//Create Array Lists to store the data sets in the classes
ArrayList<Homeless1> arrList1 = new ArrayList<Homeless1>();  //Both use the same csv file due to starting off with 2 different ones and editing
ArrayList<Homeless2> arrList2 = new ArrayList<Homeless2>();  //To have just 1 gives me errors

//Declare global variables
float border;

//Max and Min
float low, high;
int minIndex, maxIndex;

//Switch statement variable for controlp5 buttons
String mode = "Bar-Chart";

//Load data set from Homeless1()
void loadData1()
{
  String[] lines = loadStrings("homeless2.csv");
  for(String s:lines)
  {
    Homeless1 dr = new Homeless1(s);
    arrList1.add(dr);
  }
}//end loadData1

//Load data set from Homeless2()
void loadData2()
{
  String[] line = loadStrings("homeless2.csv");
  for(String r:line)
  {
    Homeless2 a = new Homeless2(r);
    arrList2.add(a);
  }
}//end loadData2


//Calculate min and max values for homeless.csv
void minmax()
{
  low = high = arrList2.get(0).homeless;
  for(int i = 0; i < arrList2.size(); i++)
  {
    if(arrList2.get(i).homeless < low)
    {
      low = arrList2.get(i).homeless;
      minIndex = i;
    }
  }
  for(int j = 0; j < arrList2.size(); j ++)
  {
    if(arrList2.get(j).homeless > high)
    {
      high = arrList2.get(j).homeless;
      maxIndex = j;
    }
  }
}//end minmax - to calculate min and max values

void setup() 
{
  size(500,500);
  loadData1();  //Again, 2 because I get an error when I try to use just 1 for both graphs
  loadData2();
  border = width * 0.1f;
  minmax();
  smooth();
  frameRate(5); //speed that the colours refresh
  cp5 = new ControlP5(this);
  
  //Add 2 buttons for both graphs
  cp5.addButton("Bar-Chart",0,0,0,80,19);
  cp5.addButton("Trend-Graph",128,420,0,80,19);
}



//Axis arrays
float[] Homelessness = {0,0,0,0,0,0}; //amount of x-axis years to write (add 1)
int[] years = {2010, 2011, 2012, 2013, 2014, 2015};

//Draw Axis's for the graphs being used in the draw method
void drawAxis(float[] data, int[] horizLabels, int verticalIntervals, float vertDataRange, float border)
{
  stroke(200, 200, 200);
  fill(200, 200, 200);  
  
  //Draw the horizontal axis  
  line(border, height - border, width - border, height - border);
  
  float windowRange = (width - (border * 2.0f));  
  float horizInterval =  windowRange / (data.length - 1);
  float tickSize = border * 0.1f;
  
    
  for (int i = 0 ; i < data.length ; i ++)
  {   
   //Draw the ticks
   float x = border + (i * horizInterval);
   line(x, height - (border - tickSize), x, (height - border));
   float textY = height - (border * 0.5f);
   
   //Print the text 
   textAlign(CENTER, CENTER);
   text(horizLabels[i], x, textY);
   
  }
  
  //Draw the vertical axis
  line(border, border , border, height - border);
  
  float verticalDataGap = vertDataRange / verticalIntervals;
  float verticalWindowRange = height - (border * 2.0f);
  float verticalWindowGap = verticalWindowRange / verticalIntervals; 
  for (int i = 0 ; i <= verticalIntervals ; i ++)
  {
    float y = (height - border) - (i * verticalWindowGap);
    line(border - tickSize, y, border, y);
    float hAxisLabel = verticalDataGap * i;
        
    textAlign(RIGHT, CENTER);  
    text((int)hAxisLabel, border - (tickSize * 2.0f), y);
  }  
}

void draw() 
{
    //If statements for implementation of the controlp5 buttons
    if( mode == "Trend-Graph");
    {
      background(0);

      fill(0, 255, 255);
      textAlign(CENTER, CENTER);
      textSize(15);
      text("Homelessness in Dublin 2010-2015", 250, 30);
      textSize(15);
      text("Most Homelessness: " + arrList2.get(maxIndex).homeless, 400, 80);
      text("Least Homelessness: " + arrList2.get(minIndex).homeless, 400, 95);
      
      //Call the drawAxis() method
      drawAxis(Homelessness, years, 5, 200, border);
      
      float windowRange = (width - (border * 2.0f));
      float dataRange = 200;      
        
      float scale = windowRange / dataRange;
      float lineWidth =  windowRange / (float) (arrList2.size() - 1);
      
      //Draw the line graph for Homelessness in Dublin
      for (int i = 1 ; i < arrList1.size() ; i ++)
      {
        stroke(255, 0, 0);
        float x1 = border + ((i - 1) * lineWidth);
        float x2 = border + (i * lineWidth);
        float y1 = (height - border) - (arrList2.get(i - 1).homeless) * scale;
        float y2 = (height - border) - (arrList2.get(i).homeless) * scale;
        line(x1, y1, x2, y2);    
       } 
      
    }
    
    if(mode == "Bar-Chart")
    {
        background(0);
        fill(255, 0, 0);
        textAlign(CENTER, CENTER);
        textSize(15);
        text("Homelessness in Dublin 2010-2015", 250, 30);
        textSize(15);
        text("Most Homelessness: " + arrList2.get(maxIndex).homeless, 400, 80);
        text("Least Homelessness: " + arrList2.get(minIndex).homeless, 400, 95);
        
        //Call the drawAxis() method
        drawAxis(Homelessness, years, 5, 200, border);
      
        float windowRange = (width - (border * 2.0f));
        float dataRange = 200;      
          
        float scale = windowRange / dataRange;
        float barWidth = (width - border * 2) / (float) (arrList1.size());
        
        //Draw the barchart for Homelessness in Dublin
        for (int i = 0 ; i < arrList1.size() ; i ++)
        {
          float x = (i * barWidth) + border;
          float y = arrList1.get(i).homeless1 * scale;
          stroke(random(0, 255), random(0, 255), random(0, 255));
          fill(random(0, 255), random(0, 255), random(0, 255));
          rect(x, height - border, barWidth, -(arrList1.get(i).homeless1) * scale);
        }
    }
    
}

// Configuring CP5 so mode is like a switch case
public void controlEvent(ControlEvent theEvent) 
{
  mode = (theEvent.getController().getName());
}

