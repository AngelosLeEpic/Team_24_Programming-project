class WidgetTextBox extends Widget{
  String textValue = "??:?? - ??:??";
  boolean active = false;
  //int xpos, ypos, wide, heigh;
  PFont font;
  WidgetTextBox(int x, int y, int w, int h, int R, PFont font){
    super(x,y,w,h,R);
    this.font = font;
  }
  
  void render() {
    if (active) {
      fill(255); // Color when active
    } else {
      fill(200); // Color when inactive
    }
    rect(xpos, ypos, wide, high, roundness);
    fill(0);
    textAlign(LEFT, CENTER);
    textFont(font);
    text(textValue, xpos + 5, ypos + high/3);
  }
  
  void input(char key) {
    if (active) {
      if (key == 10)
      {
        active = false;
        if (isStringValind())
        {
          prepareUserInput();
        } else 
        {
          textValue = "??:?? - ??:??";
        }
        
      } else if (key == 65535)
      {
        // do nothing if the user presses shift
      } else if (key == 8)
      {
        try
        {
          //println("textValue was " + textValue);
          textValue = textValue.substring(0,textValue.length() - 1); // remove the last character if the user presses backspace
          //println("textValue now is " + textValue);
        } catch ( Exception e)
        {
          textValue = "";
          // The user used backspace even tho nothing is written, do nothing
        }
      } else
      {
          textValue += key;
      }
    }
  }
  void isClicked()
  {
    if(isMouseover())
    {
      active = true; 
      textValue = "";
    } else 
    {
      active = false;
      if(isStringValind())
      {
        prepareUserInput();
      } else 
      {
        textValue = "??:?? - ??:??";
      }
    }
  }
  boolean isStringValind() 
  {
    try{
      String[] uservalues = textValue.split("-");
      uservalues[0] = uservalues[0].trim();
      uservalues[1] = uservalues[1].trim();
      return(isInputValidtimeRange(uservalues[0]) && isInputValidtimeRange(uservalues[1]));
    } catch (Exception e)
    {
      return false;
    }
  }
  void prepareUserInput(){ // Bug: when the bottom text box contains a valid input and the first box is activated the second textBox resets itself.
                           // but this does not happen vice versa 
    String[] uservalues = textValue.split("-");
    uservalues[0] = uservalues[0].trim();// we trim the whitespaces from the values
    uservalues[1] = uservalues[1].trim();
    uservalues[0] = uservalues[0].replace(":","");// we remove the colon to have the user input in pure integer format
    uservalues[1] = uservalues[1].replace(":","");
    boolean temp = false;
    for(int i = 0; i < textBoxList.size(); i++)
    {
      if(textBoxList.get(i).textValue == "??:?? - ??:??")
      {
        temp = true;
      }
    }
    if(!temp)
    {
      this.textValue = "??:?? - ??:??";
    }
  }
}
