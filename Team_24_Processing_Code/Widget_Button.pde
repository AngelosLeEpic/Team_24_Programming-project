class WidgetButton extends Widget
{
  String buttonText;
  WidgetButton(int xpos,int ypos, int W, int H,int R, String text)
  {
    super(xpos, ypos, W, H, R);
    buttonText = text;
  }
  boolean isClicked()
  {
    return(isMouseover());
  }
    
  void render()
  {
    if(active)
    {
      fill(screen.BUTTON_ON);
    }
    else         // We choose the color of the botton base on it's current status
    {
      fill(screen.BUTTON_OFF);
    }
    rect(xpos, ypos, wide, high, roundness);
    
    if(buttonText != null)
    {
      fill(screen.TEXT_COLOR);
      textSize(high*0.25);
      text(buttonText, xpos+ wide*0.05, ypos + high*0.5);
    }
  }
  /**
   * This method is exclusivly called for the tab buttons
   * If one of the buttons is active the others are all deactivated to avoid potential bugs
   * This ensures the user does not somehow have multiple tabs selected
   */
  void linkedListCheck(ArrayList<WidgetButton> buttonGroup){ // This functions is used for lists of butons where only one button may be on at a time
  // Afte a button is clicked, the button goes through a list that includes itself and it's fellow buttons in the group, and makes sure only it is active
    for(int i = 0; i < buttonGroup.size(); i++)
    {
      if(buttonGroup.get(i) != this)
      {
        buttonGroup.get(i).active = false;
      }
    }
  }
}
