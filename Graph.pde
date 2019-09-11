/* Graph: this class display the data in several ways.
 For detailed, the class allow the users to step over each date and see the data
 For overview,this allow the user to view the entire graph all at once
 For water color and clarity, an overview is shown to see how the lake colour changed over time
 Note: for this class only the constructor is loosely based on the Datamodel
 */

class Graph
{
  //VARIABLES
  protected PVector hBounds, vBounds, h, v;
  protected Table values;
  protected Table _waterClarity;
  protected Table _waterColour;
  protected String _lakeTitle;
  protected String _parameter;
  protected color _color;
  protected Lake _lake;
  protected  ArrayList <PVector> p;
  //CONSTRUCTOR: this set the top and the bottom of the graph 
  Graph(String parameter, int h_min, int h_max, float v_min, float v_max, Table table, Lake l, color c) {
    hBounds = new PVector (h_min, h_max);//store max and min bounds for the graph (x/h)
    vBounds = new PVector (v_min, v_max);//store max and min bounds for the graph (y/v)

    //Map supplied data min and max values to desired dimensions min and max, for each axis 
    h = new PVector(map(hBounds.x, hBounds.x, hBounds.y, 200, width-200), map(hBounds.y, hBounds.x, hBounds.y, 200, width-200) );
    v = new PVector(map(vBounds.x, vBounds.x, vBounds.y, 200, height-200), map(vBounds.y, vBounds.x, vBounds.y, 200, height-200) );
    //Initialize data
    _lake = l;
    _lakeTitle = l.getLakeName();
    _parameter = parameter;
    _color = c;
    values = table;//provide a reference to the values
    p = new ArrayList<PVector>();
    _waterColour = _lake.getParameterData("Water_Colour");
    _waterClarity = _lake.getParameterData("Water_Clarity");
  }

  //PRIVATE METHODS///////
  //This select the color for the colour mode
  private color selectColor(String s) {
    if (s.contains("green")) {
      return #17D361;
    }
    else if (s.contains("blue")) {
      return #1756AD;
    } else if (s.contains("yellow")) {
      return #CEBA1B;
    } else if (s.contains("grey")) {
      return #A6B4A6;
    } else if (s.contains("brown")) {
      return #7E4F29;
    } else if (s.contains("black")) {
      return #000000;
    } else if (s.contains("milky")) {
      return #F0EEED;
    }
    return #FFFFFF;
  }

  //displayColor: this display color when index is set to -3, this show all the lake colour from the start to end side by side
  private void displayColor() {
    int x = 0;
    for (TableRow row : _waterColour.rows()) {
      rectMode(CENTER);
      fill(selectColor(row.getString("VALUE")));
      rect(x, height/2, width/_waterColour.getRowCount(), height);
      x+= width/_waterColour.getRowCount();
    }
    fill(0);
     text("From " +_waterColour.getString(0,"DATE")+ " to " + _waterColour.getString(_waterColour.getRowCount() -1,"DATE") , width - 400, height - 20);
  }
  //displayClarity: this show the lake clarity when set to -2
  private void displayClarity() {
    int x = 0;
    for (TableRow row : _waterClarity.rows()) {
      // if (index < _waterClarity.getRowCount()) {
      rectMode(CENTER);
      noStroke();
      fill(#FFFFFF, 100 - row.getInt("VALUE")/2);
      rect(x, height/2, width/_waterClarity.getRowCount(), height);
      x+= width/_waterClarity.getRowCount();
    }
    fill(0);
    text("Clear: White, Light Grey: Turbid, Dark Grey/Black: Opaque", width - 400, height - 20);
  }
  //displayComparison: this show the max and the min in comparison with the volume
  private void displayComparison() {
    int width_vol =int( map(_lake.x, -85, 85, 0 + 100, width/2 - 300));
    int height_vol =int( map(_lake.y, -180, 180, 0 + 100, height - 300));
    float volume =Math.abs(_lake.x) * Math.abs(_lake.y) * Math.abs(_lake.z)/1000;
    float percent_first = _lake.getMin(_parameter);
    float percent_last = _lake.getMax(_parameter);
    float average = _lake.getAverage(_parameter);
        fill(_color,200);
            rectMode(CENTER);
    rect(400, 0, width_vol, percent_first/average*height_vol);
    rect(width - 400, 0, width_vol, percent_last/average*height_vol);
    fill(255);
    text("Min: " + percent_first + "mg/L", 400, height/2+200);
    text("Max: " + percent_last + "mg/L", width - 400, height/2+200);
    text("Average: " + average +  "mg/L", 400, height/2+100);
    text("Average: " + average +  "mg/L", width-400, height/2+100);
    text("Volume: " + volume + "L", width - 400, height/2+150);
    text("Volume: " + volume + "L", 400, height/2+150);
  }
  //DetailedGraph: when index is >=0 , detailed mode is activated to allow the users to step over each date
  private void detailedGraph(int index) {
    noStroke();
    fill(_color);
    ellipse(p.get(0).x, p.get(0).y, 20, 20); //display the first and the last point in bigger size to show comparison
    ellipse(p.get(p.size()-1).x, p.get(p.size()-1).y, 20, 20);
    if (index >= 0 && index < p.size() -1 ) { //check whether the index is valid
      for (int i = 1; i < index; i++) {
        stroke(_color);
        noFill();
        line(p.get(i-1).x, p.get(i-1).y, p.get(i).x, p.get(i).y);
        noStroke();
        fill(_color);
        ellipse(p.get(i).x, p.get(i).y, 5, 5);
      }
      textSize(12);
      textAlign(RIGHT);
      text(_parameter, p.get(0).x -30, p.get(0).y);
      textAlign(LEFT);
      text(int(values.getFloat(index, "VALUE")) +","+values.getString(index, "DATE"), p.get(p.size()-1).x +20, p.get(p.size()-1).y);
      textSize(20);
      text("Press the left or right arrow to step through graph", 650, height - 20); //instruction for users
    } else {
      overviewGraph(); //after it is done, show overview
    }
  }
  //displayGraph: this display all the data in the graph for the users to get an overall look on how the lake, the data is visualize using a line graph, it is set when index = -1
  private void overviewGraph() {
    textSize(40);
    fill(255);
    text(_lakeTitle, width/2, 70);

    for (int i = 1; i < p.size(); i++) {
      stroke(_color);
      noFill();
      line(p.get(i-1).x, p.get(i-1).y, p.get(i).x, p.get(i).y);
      noStroke();
      fill(_color);
      ellipse(p.get(i).x, p.get(i).y, 5, 5);
    }
    ellipse(p.get(0).x, p.get(0).y, 20, 20);
    textSize(12);
    text(_parameter, p.get(0).x -70, p.get(0).y);
  }
  //PUBLIC METHODS///////
  //loadGraph: this select what mode to show and load vector as well
  public void loadGraph(int index) {
    if (values != null) {
      PVector pos = new PVector(0, 0);//temporary vector to hold the data point
      for (TableRow row : values.rows()) {
        pos.x = row.getFloat("DAYS");
        pos.y = row.getFloat("VALUE");
        p.add(new PVector(map(pos.x, hBounds.x, hBounds.y, 200, width-200), map(pos.y, vBounds.x, vBounds.y, height-100, 100))); //get the value and map it to fit the screen with 200px border 
      }
      //This select the right mode
      if (index == - 1 ) {
        overviewGraph();
      } else if (index == -2 ) {
        displayClarity();
      } else if (index == -3) {
        displayColor();
      } else if (index == -4) {
        displayComparison();
      } else {
        detailedGraph(index);
      }
    }
  }
}
