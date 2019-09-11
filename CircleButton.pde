//CircleButton: this class extends button class, this draw the icons with flask to represent the water sample from different lakes
class CircleButton extends Button{
  //Define variables
  private int _size;
  private float _tli;
  private String _grade;
  //CONSTRUCTOR: this initialize the icons with the correct x,y, caption, grade, tli and image
  public CircleButton(int x,int y,String caption, int size, String grade,float tli)
  {
    super(x,y,caption);
    _size = size;
    _tli = tli;
    _grade = grade;
    selectColor(grade);
  }
  
  //SelectColor: this choose the color based on the grade
  private void selectColor(String grade){
    if(grade.equals("Oligotrophic")){
      _buttonColor =#52A1FF;
    }
        else if(grade.equals("Microtrophic")){
       _buttonColor =#36F2AB;
    }
        else if(grade.equals("Supertrophic")){
       _buttonColor = #3236EA;
    }
        else if(grade.equals("Mesotrophic")){
       _buttonColor = #42E366;
    }
            else if(grade.equals("Hypertrophic")){
       _buttonColor =#42E366;
    }
            else if(grade.equals("Eutrophic")){
       _buttonColor = #42E366;
    }
    else{
        _buttonColor = #FFFFFF;
    }
  }
  //This draw the button based on the grade
  public void drawButton(){
  ellipseMode(CENTER);
    int flask_size = _size  + 2*_size/3;
    image(_flask,_centre.x - flask_size/2,_centre.y -flask_size/2 - 10, flask_size,flask_size);
    if(_isSelected){
    fill(#FF120A);
    }
    else{
    fill(_buttonColor);}
  ellipse(_centre.x,_centre.y,_size,_size);
    textAlign(CENTER);
    textFont(_font);
    fill(0);
    text(_caption,_centre.x,_centre.y + _size +15);
       text(_grade,_centre.x,_centre.y + _size +30);
       
       fill(0);
    text(nf(_tli,0,2),_centre.x,_centre.y);
  }
   //isClicked: check if the button is clicked on
    public boolean isClicked(int x, int y)
  {
    if (pow(x - _centre.x, 2) + pow(y - _centre.y, 2) < pow(_size/2, 2))
    {
      _isSelected = true;
      return true;
    } else
    {
      _isSelected = false;
      return false;
    }
  }


}
