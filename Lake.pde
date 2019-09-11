/* Lake: this class contains data related to the lake and draw the graph
 */
class Lake
{
  //VARIABLES
  public  String name;
  protected String site_id, type, grade2004, grade2010;
  protected float x, y, z, tli2004, tli2010;
  protected ArrayList<Graph> _graphList;
  protected Table lakeData; //Table for the object to store all data in

  //PROPERTIES
  //getLakeGrade(): this return the grade
  public String getLakeGrade(int year) {
    if (year == 2004) {
      return grade2004;
    }
    return grade2010;
  }
  //GetLakeName(): this return the name of the lake
  public String getLakeName() {
    return name;
  }
  //GetLakeType(): this return the type of the lake
  public String getLakeType() {
    return type;
  }
  //GetLakeName(): this return the name of the TLI of the lake
  public float getLakeTLI(int year) {
    if (year == 2004) {
      return tli2004;
    }
    return tli2010;
  }
  
  //CONSTRUCTOR: this load in the data for the lake //This is based on the reference model
  public Lake(String _site_id, String _name, String _type, String g1, String g2, float _x, float _y, float _z, float tli1, float tli2) {
    //create the table to store only the data for this table
    lakeData = new Table(); //local table to store the data relevant to this lake
    lakeData.addColumn("SITE_ID");
    lakeData.addColumn("DATE");
    lakeData.addColumn("PARAMETER");
    lakeData.addColumn("VALUE");
    lakeData.addColumn("UNITS");

    site_id = _site_id;
    name = _name;
    type = _type;
    grade2004 = g1;
    grade2010 = g2;
    x = _x;
    y = _y;
    z = _z;
    tli2004 = tli1;
    tli2010 = tli2;
  }
  //DumpBasicData: This is used for double checking whether the file has loaded properly/ based on the referenced model
  public void dumpBasicData() {
    println("Dumping basic DataManager about lake >>");
    print(site_id+",");
    print(name+",");
    print("<"+type+">");
    print(grade2004+",");
    print(grade2010+",");
    print(x+",");
    print(y+",");
    print(z+",");
    print(tli2004+",");
    print(tli2010+".");
    println();
  }
    
  //toString: this return the details on the bottom of the screen when clicked
  public String toString() {
    return "Site ID:    " + site_id +"   " +  "Name:    " + name + "    " +  " Type: " + type + " " + " X: " + x + " Y: " + y + " Altitude " + z;
  }
  //loadDataGraph: this initalize the graph with the right color and parameter
  private void loadDataGraph(String para, color c) {

    String parameter = para;
    float minValue = getMin(parameter); //careful with names, this is currently case sensitive!!!
    float maxValue = getMax(parameter);
    String startDate = getStartDate(parameter);
    String endDate = getEndDate(parameter);
    int totalDays = compareDates.betweenDates(startDate, endDate);
    _graphList.add( new Graph(parameter, 0, totalDays, minValue, maxValue, getParameterData(para), this, c));
  }
  //This create the filter if it is in filter mode or comparison mode
  private void selectGraph(int index, String parameter) {
    if (index == -4 || index == -5) {
      if (_graphList.isEmpty() == false) {
        if (parameter == "PHOSPHORUS") {
          _graphList.get(0).loadGraph(index);
        } else if (parameter == "NITROGEN") {
          _graphList.get(1).loadGraph(index);
        } else if (parameter == "CHLOROPHYLL") {
          _graphList.get(2).loadGraph(index);
        } else if (parameter == "TURBIDITY") {
          _graphList.get(3).loadGraph(index);
        }
      }
    }
  }
  //drawGraph: this display the graph by calling the drawGraph function from graph
  public void drawGraph(int index, String parameter) {
    _graphList = new ArrayList<Graph>();
    // Lake thisLake = current;
    background(0);
    loadDataGraph("Total_Phosphorus", #F70C20);
    loadDataGraph("Total_Nitrogen", #0CF7E2);
    loadDataGraph("Chlorophyll", #FFCB0D);
    loadDataGraph("Turbidity", #E30ED5);
    if (index == -4 || index == -5) {
      selectGraph(index, parameter);
    } else {
      for (Graph g : _graphList) {
        g.loadGraph(index);
      }
    }
  }  
  
  //This return the largest value to act as the top of the y axis
  public float getAverage(String parameter) {
    float value = 0;
    float total = 0;
    int count = 0;
    for (TableRow row : lakeData.matchRows(parameter, "PARAMETER")) {
      value = row.getFloat("VALUE");
      total += value;
      count++;
    }
    return total/count;
  }
  /*THIS PART IS REFERENCED FROM THE DATAMODEL*/
  //This return the smallest value from the data type to graph as the start of y axis
  public float getMin(String parameter) {
    float minVal = 0;
    float value = 0;
    boolean isNull = true;
    for (TableRow row : lakeData.matchRows(parameter, "PARAMETER")) {
      //println(row.getString("name") + ": " + row.getString("type"));
      value = row.getFloat("VALUE");
      if (minVal>value || isNull) minVal = value;
      isNull = false;
    }
    return minVal;
  }
  //This return the largest value to act as the top of the y axis
  public float getMax(String parameter) {
    float maxVal = 0;
    float value = 0;
    boolean isNull = true;
    for (TableRow row : lakeData.matchRows(parameter, "PARAMETER")) {
      value = row.getFloat("VALUE");
      if (maxVal<value || isNull) maxVal = value;
      isNull = false;
    }
    return maxVal;
  }

  //this return the first date to act as the 0 of x axis
  public String getStartDate(String parameter) {
    TableRow result = lakeData.matchRow(parameter, "PARAMETER");
    return result.getString("DATE");
  }
  //this return the last date to act as the end of the x axis
  public String getEndDate(String parameter) {
    String result = "";
    for (TableRow row : lakeData.matchRows(parameter, "PARAMETER")) {
      result = row.getString("DATE");
    }
    return result;
  }
  //This add another row of data onto the lake
  public void addTableRow(TableRow r) {
    lakeData.addRow(r);
  }
  //This get the table with the passed in parameter
  public Table getParameterData(String parameter) {
    //THIS PART IS NOT IN THE REFERENCED MODEL AND IS EXTENDED
    //WaterColor needs a specific parse in where value is not float but a string
    Table t = new Table();
    t.addColumn("VALUE");
    t.addColumn("DATE");
    t.addColumn("DAYS");
    if (parameter == "Water_Colour") {
      String value;
      String date;
      String unit;
      for (TableRow row : lakeData.matchRows(parameter, "PARAMETER")) {
        value = row.getString("VALUE");
        date = row.getString("DATE");
        unit = row.getString("UNITS");
        TableRow tr = t.addRow();
        tr.setString("VALUE", value);
        tr.setString("DATE", date);
        tr.setString("UNIT", unit);
        tr.setInt("DAYS", compareDates.betweenDates(getStartDate(parameter), date));
      }
    } else {
      float value;
      String date;
      for (TableRow row : lakeData.matchRows(parameter, "PARAMETER")) {
        value = row.getFloat("VALUE");
        date = row.getString("DATE");
        TableRow tr = t.addRow();
        tr.setFloat("VALUE", value);
        tr.setString("DATE", date);
        tr.setInt("DAYS", compareDates.betweenDates(getStartDate(parameter), date));
      }
    }
    return t;
  }
}
