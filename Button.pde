//Button: this class is the super class for the circlebutton(to draw the lake) and the rectangle button for the navigation
abstract class Button{
  protected PVector _centre;
  protected color _buttonColor;
    protected String _caption; //For
      protected PFont _font; //This is the current font
        protected boolean _isSelected; //this is for label to show which screen is currently being display
        protected boolean _isInverted; //this is to use with black background
  
  //CONSTRUCTOR: this initialize the center, caption, font and set invert to false
  public Button(int x,int y,String caption){
    _centre = new PVector(x,y);
    _caption = caption;
     _font = createFont("Helvetica",14); 
     _isInverted = false;
  }
  //Invert: this allow the set the color to white
    public void setInvert(boolean invert){
     _isInverted = invert;
  }
  //This return the text on the button
  public String getCaption(){
    return _caption;
  }
  //This is for setting label
    public void setSelect(boolean current){
    _isSelected = current;
  }
  abstract void drawButton();
  abstract boolean isClicked(int x,int y);
  
}
