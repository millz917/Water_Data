class DataManager
{
  /* This class demonstrates loading data from CSV files for use in Lake objects
   METHODS:
   public void processLakeData(String csvfile) 
   public void register(LakeManager l) 
   public void processLakeData(String csvfile, boolean printToConsole)
   public void printLakeDataManager(int n)
   public void printLakeDataManager(String aName)
   public void processParameterDataFiles(String[] files)
   public void processParameterDataFiles(String[] files, boolean printToConsole)
   */
  //VARIABLES
  protected LakeManager lm;
  protected ArrayList<Button> _iconsList;
  protected ArrayList<RectangleButton> _navList;
  protected ArrayList<RectangleButton> _arrowList;
  protected ArrayList<RectangleButton> _secondNavList;
  protected ArrayList<RectangleButton> _filterList;
  private int _noScreen;
  private boolean _graphEnabled;
  private int _graphIndex;
  private String _filter;
  private Lake _current;


  /*CONSTRUCTOR*/
  public DataManager() {
    _iconsList = new ArrayList<Button>();
    _navList = new ArrayList<RectangleButton>();
    _secondNavList = new ArrayList<RectangleButton>();
    _arrowList = new ArrayList<RectangleButton>();
    _filterList = new ArrayList<RectangleButton>();
    //Initialize the first screen
    generateFirstNav();
    _graphEnabled = false;
  }
   /*THIS PART HAS BEENT TAKEN FROM THE DATAMODEL REFERENCE MODEL*/

  /*DATA PARSING*/
  protected void register(LakeManager l) {
    lm = l;
  }
  public String getDataName(String filename) {
    String [] file = split(filename, '.');
    String name = file[0];
    return name;
  }
  //This process the overview data
  public void processLakeData(String csvfile) {
    this.processLakeData(csvfile, false);
  }
  //This process the parameter data
  public void processParameterData(String csvfile) {
    this.processParameterData(csvfile, false);
  }
  //This process the file parse in for data
  public void processParameterDataFiles(String[] files) {
    for (String s : files) {
      this.processParameterData(s, false);
    }
  }
  //This process the file and print out onto the screen
  public void processParameterDataFiles(String[] files, boolean printToConsole) {
    for (String s : files) {
      this.processParameterData(s, printToConsole);
    }
  }
  //This extract the data and put it into the table
  public void processParameterData(String csvfile, boolean printToConsole) {
    /* Method to add DataManager from a CSV file */

    if (printToConsole) println("Adding lake data from file " + csvfile);
    Table table;
    table = loadTable(csvfile, "header");

    if (printToConsole) println(table.getRowCount() + " total rows in table");
    for (TableRow row : table.rows()) {
      //find lake to receive the DataManager using the ID
      String lakeID = row.getString("SITE_ID");
      Lake l = lm.getLakeByID(lakeID);
      if (l != null) {
        l.addTableRow(row);
      } else {
        println("lake object not found to attach row data to");
      }
    }
    if (printToConsole) {
      println("Loading lake data complete! <<" + csvfile);
      println();
    }
  }

  //This process overview data
  public void processLakeData(String csvfile, boolean printToConsole) {
    /* Ingests DataManager from the supplied CSV file to create the lake objects from */
    if (printToConsole) println("Adding ALL lakes from file >> " + getDataName(csvfile));
    Table table;
    table = loadTable(csvfile, "header");

    if (printToConsole) {
      println(table.getRowCount() + " total rows in table"); 
      print("These are the column titles >>");
      println(table.getColumnTitles());
    }

    for (TableRow row : table.rows()) {
      String id = row.getString(0);//"SITE_ID"); //On mac it is incorrectly reading the first character
      String name = row.getString("NAME");
      String siteType = row.getString("SITE_TYPE");
      String grade2004 = row.getString("GRADE20042006");
      String grade2010 = row.getString("GRADE2010");
      float x = row.getFloat("X");
      float y = row.getFloat("Y");
      float z = row.getFloat("ALTITUDE");
      float tli2004 = row.getFloat("TLI20042006");
      float tli2010 = row.getFloat("TLI2010");


      /* Create a new lake object to receive the data */
      if (printToConsole) println("Creating and adding lake object named >> " + name);
      Lake thisLake = new Lake(id, name, siteType, grade2004, grade2010, x, y, z, tli2004, tli2010);
      lm.addLake(thisLake);
    }

    if (printToConsole) {
      println("Loading complete! <<");
      println();
    }
  }
   /*REFERENCE ENDED*/

  /*UI METHODS*/
  //This generate the first navigation for the first screen
  private void generateFirstNav() {
    RectangleButton label2004 = new RectangleButton(50, height-25, "2004", 100, 50);
    RectangleButton label2010 = new RectangleButton(150, height-25, "2010", 100, 50);
    RectangleButton left = new RectangleButton(20, height/2, "", 20, 50);
    RectangleButton right = new RectangleButton(width - 20, height/2, "", 20, 50);
    RectangleButton enter = new RectangleButton(width - 50, height - 25, "ENTER", 100, 50);
    _navList.add(label2004);
    _navList.add(label2010);
    _navList.add(enter);
    _arrowList.add(left);
    _arrowList.add(right);
  }
  //This generate the second navigation for the second screen
  private void generateSecondNav() {  
    //Initialize
        _noScreen = 0;
    _graphIndex = -1;
    _filter = "";
    //Generate button
    RectangleButton exit = new RectangleButton(width - 50, height - 25, "EXIT", 100, 50);
    RectangleButton overview = new RectangleButton(50, height-25, "OVERVIEW", 100, 50);
    RectangleButton detailed = new RectangleButton(150, height-25, "DETAILED", 100, 50);
    _secondNavList.add(exit);
    _secondNavList.add(overview);
    _secondNavList.add(detailed);
    _secondNavList.add(new RectangleButton(250, height-25, "CLARITY", 100, 50));
    _secondNavList.add(new RectangleButton(350, height-25, "COLOUR", 100, 50));
    _secondNavList.add((new RectangleButton(450, height-25, "COMPARISON", 100, 50)));
    _secondNavList.add((new RectangleButton(550, height-25, "FILTER", 100, 50)));
    _filterList.add(new RectangleButton(width - 75, 200, "PHOSPHORUS", 150, 50));
    _filterList.add(new RectangleButton(width - 75, 300, "NITROGEN", 150, 50));
    _filterList.add(new RectangleButton(width - 75, 400, "CHLOROPHYLL", 150, 50));
    _filterList.add(new RectangleButton(width - 75, 500, "TURBIDITY", 150, 50));
  }
  //NextScreen(): this clear the icons list and reset the screen
  private void nextScreen() {
    _iconsList.clear();
    _graphEnabled = false;
    generateFirstNav();
  }
    /*DRAW UI*/
  
  //This draw the user interface by calling the right method
  public void drawUI() {
    if (_graphEnabled == false) {
      noFill();
      textSize(40);
      fill(0);
      textAlign(CENTER);
      text("WATER DATA", width/2, 70);
      drawBottles(_noScreen);
      if (_current != null) {
        fill(0);
        text(_current.toString(), width/2, height - 30);
      }
    } else {
      drawGraph();
    }
  }
  //DrawGraph(): This check which mode it is in
  private void drawGraph() {
    _current.drawGraph(_graphIndex, _filter);
    for (Button b : _secondNavList) {
      if (b.getCaption() == "OVERVIEW" && _graphIndex == -1) {
        b.setSelect(true);
      } else  if (b.getCaption() == "CLARITY" && _graphIndex == -2) {
        b.setSelect(true);
      } else  if (b.getCaption() == "COLOUR" && _graphIndex == -3) {
        b.setSelect(true);
      } else  if (b.getCaption() == "COMPARISON" && _graphIndex == -4) {
        b.setSelect(true);
        for (Button filter : _filterList) {
          filter.drawButton();
        }
      } else  if (b.getCaption() == "FILTER" && _graphIndex == -5) {
        b.setSelect(true);
        for (Button filter : _filterList) {
          filter.drawButton();
        }
      } else  if (b.getCaption() == "DETAILED" && _graphIndex >=0) {
        b.setSelect(true);
        for (Button arrow : _arrowList) {
          arrow.setInvert(true);
          arrow.drawButton();
        }
      }
      b.drawButton();
    }
  }
  //drawUI: THIS DRAW THE USER INTERFACE for the first screen by drawing the bottles
  //The max number is 20 bottles per screen
  private void drawBottles(int index) {
    if (index >= 0) {
      lm.createIcon();
      for (Button arrow : _arrowList) {
        arrow.drawButton();
      }
      //This show which screen is currently on
      for (Button b : _navList) {
        b.setSelect(false);
        if (b.getCaption() == "2004" && index <2) {
          b.setSelect(true);
        } else if (b.getCaption() == "2010" && index >=2) {
          b.setSelect(true);
        }
        b.drawButton();
      }
      //For remembering format
      for(Button b : _iconsList){
        if(_current != null && _current.getLakeName() == b.getCaption()){
          b.setSelect(true);
        }
      }
      //This part load the next set of icons
      if (index <4 ) {
        nextScreen();
        for (CircleButton b : lm.getScreen(index)) {
          _iconsList.add(b);
          b.drawButton();
        }
      }
    }
  }
  /*CHECK BUTTON*/
  //checkButtonClick() : IF BUTTON IS CLICKED by calling the suitable methods
  public void checkButtonClick(int x, int y) {
    if (_graphEnabled == false) {
      checkFirstNav(x, y);
    } else {
      checkSecondNav(x, y);
    }
  }
  //checkFirstNav: this check the which button is pressed in the first screen
  private void checkFirstNav(int x, int y) {
    for (Button nav : _navList) {
      if (nav.isClicked(x, y) ) {
        if (_current != null && nav.getCaption() == "ENTER" ) {
          _graphEnabled = true;
          generateSecondNav();
        } else if (nav.getCaption() == "2004") {
          _noScreen= 0;
        } else if (nav.getCaption() == "2010") {
          _noScreen= 2;
        }
      }
    }
    for (int i = 0; i < _iconsList.size(); i++) {
      if (_iconsList.get(i).isClicked(x, y)) {
        String caption = "";
        caption = _iconsList.get(i).getCaption();
        _current = lm.getLakeByName(caption);
      }
    }
    for (int i = 0; i < _arrowList.size(); i++) {
      if (i == 0 && _arrowList.get(i).isClicked(x, y) && _noScreen>0) {
        _noScreen--;
        drawUI();
        _current = null;
      } else if (i == 1 && _arrowList.get(i).isClicked(x, y) && _noScreen < 3) {
        _noScreen++;
        drawUI();
        _current = null;
      }
    }
  }
  //CheckSecondNav: this check the navigation once you are in the graph screen
  private void checkSecondNav(int x, int y) {
    for (Button b : _secondNavList) {
      if (b.isClicked(x, y)) {
        if (b.getCaption() == "EXIT") {
          _graphEnabled = false;
          _current = null;
        } else if (b.getCaption() == "OVERVIEW") {
          _graphIndex = -1;
        } else if (b.getCaption() == "DETAILED") {
          _graphIndex = 0;
        } else if (b.getCaption() == "CLARITY") {
          _graphIndex = -2;
        } else if (b.getCaption() == "COLOUR") {
          _graphIndex = -3;
        } else if (b.getCaption() == "COMPARISON") {
          _graphIndex = -4;
          _filter = "";
        } else if (b.getCaption() == "FILTER") {
          _graphIndex = -5;
          _filter = "";
        }
      }
    }
    //If filter list is enabled it updates the filter
    for (Button filter : _filterList) {
      if (filter.isClicked(x, y)) {
        _filter = filter.getCaption();
      }
    }

    //If in detailed: check whether the users have stepped through the whole graph , increase/decrease time stamp by 1 
    if (_graphIndex >=0) {
      for (int i = 0; i < _arrowList.size(); i++) {
        if (i == 0 && _arrowList.get(i).isClicked(x, y) && _graphIndex>=0) {
          _graphIndex--;
        } else if (i == 1 && _arrowList.get(i).isClicked(x, y) && _graphIndex <200) {
          _graphIndex++;
        }
      }
    }
  }
}
