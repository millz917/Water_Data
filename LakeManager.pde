/* LakeManager: This graph stores all the lakes and contains all the icons related to the lake
 */
class LakeManager
{
  //VARIABLES
  public ArrayList<Lake> lakes;
  public ArrayList<CircleButton> icons2004;
  public ArrayList<CircleButton> icons2010;
  //CONSTRUCTOR: this initializes the arraylist of icons
  LakeManager() {
    lakes = new ArrayList<Lake>(); //to store all lake objects
    icons2004 = new ArrayList<CircleButton>(); //store all the icons for 2004 lakes
    icons2010 = new ArrayList<CircleButton>(); //store all the icons for 2010 lakes
  }
  //PROPERTIES
  //This return the lake by name /*THIS IS FROM THE REFERENCED MODEL*/
  public Lake getLakeByName(String aName) {
    //returns a lake object that matches a given name (case sensitive!)
    for (Lake l : lakes) {
      if (aName.equals(l.name)) return l;
    }
    println("WARNING: getLakeByName(String aName) was unable to find a lake named " + aName);
    return null;
  }
  //This return lake by ID /*THIS IS FROM THE REFERENCED MODEL*/
  public Lake getLakeByID(String anID) {
    for (Lake l : lakes) {
      if (anID.equals(l.site_id)) return l;
    }
    println("WARNING: getLakeByID(String anID) was unable to find a lake id of " + anID);
    return null;
  }
  //This return lake by number /*THIS IS FROM THE REFERENCED MODEL*/
  public Lake getLakeByInt(int n) {
    if (n<lakes.size()) return lakes.get(n);
    println("WARNING: getLakeByInt(int n) was unable to find a lake numbered " + n);
    return null;
  }
  //This get the amount of lakes in lakeManager
  public int getSize() {
    return lakes.size();
  }
  //METHODS//
  //AddLake(): This all more lake onto the arraylist /*THIS IS FROM THE REFERENCED MODEL*/
  public void addLake(Lake lake) {
    lakes.add(lake); //add the provided lake object to the array
  }
  //This create the icons for all the lakes in the arraylist
  public void createIcon() {
    int buttonX = 150;
    int buttonY = 150;
    for (Lake l : lakes) {
      icons2004.add(new CircleButton(buttonX, buttonY, l.getLakeName(), 40, l.getLakeGrade(2004), l.getLakeTLI(2004))); 
      icons2010.add(new CircleButton(buttonX, buttonY, l.getLakeName(), 40, l.getLakeGrade(2010), l.getLakeTLI(2010)));
      //Calculate the gap
      if (buttonX + 200 > width) {
        buttonX = 150;
        buttonY += 125;
      } else {
        buttonX += 250;
      }
      //Reset for the second page
      if (icons2004.size() % 20 == 0 || icons2010.size() % 20 == 0) {
        buttonX = 150;
        buttonY = 150;
      }
    }
  }
  //getScreen(): This select max 20 lakes per screen 
  public ArrayList<CircleButton> getScreen(int index) {
    if (index == 0) {
      return getIconsScreen(icons2004, 0, 20);
    } else if (index == 1) {
      return getIconsScreen(icons2004, 20, 31);
    } else  if (index == 2) {
      return getIconsScreen(icons2010, 0, 20);
    }
    return getIconsScreen(icons2010, 20, 31);
  }
  //getIconsScreen: This create a new arraylist with the max-20 screen to display
  private ArrayList<CircleButton> getIconsScreen(ArrayList<CircleButton> year, int start, int end) {
    ArrayList<CircleButton> result = new ArrayList<CircleButton>();
    for (int i = start; i < end; i++) {
      result.add(year.get(i));
    }
    return result;
  }
}
