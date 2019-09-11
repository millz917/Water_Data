//Emily Nguyen 1347568
//CLASS VARIABLES
LakeManager lakeManager;
CompareDates compareDates;
DataManager dataManager;
PImage _flask;
void setup() {
  size(1280, 720);
  _flask = loadImage("flask.png");
  /*THIS IS FROM THE REFERENCED MODEL*/
  dataManager = new DataManager(); //object to store and operate on DataManager 
  lakeManager = new LakeManager(); //stores the lakes detailed
  compareDates = new CompareDates(); //allows comparison between dates reference to all lake objects
  dataManager.register(lakeManager); //registers the lakemanager so it will receive lake objects
  /* Ingests information about all lakes from provided file, passes to lakeManager */
  dataManager.processLakeData("overall_lake_data.csv", false);
  /* Add information from each individual source to the DataManager object */
  String[] filesToProcess = {
    "turbidity.csv", "water_clarity.csv", "water_colour.csv", 
    "total_nitrogen.csv", "chlorophyll.csv", "total_phosphorus.csv"
  };
  dataManager.processParameterDataFiles(filesToProcess, false); //this load the individual files to lakes
  noLoop();
  /*REFERENCED END*/
}

void draw() {
     background(255);
  dataManager.drawUI();} //This draw the UI

void mousePressed() {
  //This check which button is pressed by calling the handle click from datamanager
  dataManager.checkButtonClick(mouseX, mouseY);
  redraw();
}

void keyPressed() {
  if (keyCode == ENTER) {
    saveFrame("A03-FINAL-######.jpeg");
  }
}
