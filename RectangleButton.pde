//RectangleButton: this class extends button
class RectangleButton extends Button {
  //VARIABLES
  private int _bHeight;
  private int _bWidth;
  //CONSTRUCTOR: this initialize the button width and height and called the superclass constructor
  public RectangleButton(int x, int y, String caption, int bWidth, 
    int bHeight)
  {
    super(x, y, caption);
    _bHeight = bHeight;
    _bWidth = bWidth;
  }
  //METHODS
  //drawButton: this draw the button depending on the requirement
  public void drawButton() {
    rectMode(CENTER);
    if (_isSelected) { //if selected is set, red button is drawn
      fill(#FF120A);
    } else if (_isInverted) { //if inverted is set, button is draw in white
      fill(#FFFFFF);
    } else {
      fill(_buttonColor);
    }
    rect(_centre.x, _centre.y, _bWidth, _bHeight);
    textAlign(CENTER);
    textFont(_font);
    fill(#FFFFFF);
    text(_caption, _centre.x, _centre.y);
  }
  //isClicked() this checked whether this button is pressed
  public boolean isClicked(int x, int y)
  {
    boolean withinx = false;
    boolean withiny = false;
    if (x > _centre.x - _bWidth/2 && x < _centre.x + _bWidth/2)
    {
      withinx = true;
    }
    if (y > _centre.y - _bHeight/2 && y < _centre.y + _bHeight/2)
    {
      withiny = true;
    }
    _isSelected = withinx && withiny;
    return _isSelected;
  }
}
